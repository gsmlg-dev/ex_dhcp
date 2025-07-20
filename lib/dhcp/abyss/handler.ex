defmodule DHCP.Abyss.Handler do
  @moduledoc """
  DHCP Handler for :abyss UDP server integration.
  
  Provides a thin adapter layer between :abyss UDP server and DHCP.Server core.
  """

  # Note: :abyss module and behaviour are optional dependencies
  # This code is designed to work with :abyss UDP server when available
  # @behaviour :abyss_handler

  alias DHCP.Server
  alias DHCP.Message

  @doc """
  Abyss handler callback for UDP packet handling.
  """
  def handle_packet(packet, %{src_ip: src_ip, src_port: src_port}, state) do
    case Message.from_iodata(packet) do
      %Message{} = message ->
        {server_state, responses} = Server.process_message(state.server_state, message, src_ip, src_port)
        
        # Send responses
        Enum.each(responses, fn response ->
          binary_response = DHCP.to_iodata(response)
          if Code.ensure_loaded?(:abyss) do
            :abyss.send_packet(state.socket, binary_response, src_ip, src_port)
          else
            {:error, ":abyss dependency not available"}
          end
        end)
        
        {:ok, %{state | server_state: server_state}}
      
      _error ->
        {:ok, state}  # Ignore malformed packets
    end
  end

  @doc """
  Initialize the DHCP handler with configuration.
  """
  def init(config) do
    server_state = Server.init(config)
    
    %{
      server_state: server_state,
      socket: nil  # Will be set by :abyss
    }
  end

  @doc """
  Periodic cleanup of expired leases.
  """
  def handle_info(:expire_leases, state) do
    server_state = Server.expire_leases(state.server_state)
    {:ok, %{state | server_state: server_state}}
  end

  def handle_info(_msg, state) do
    {:ok, state}
  end

  @doc """
  Start DHCP server with :abyss.
  
  ## Options
  
    * `:port` - UDP port to bind to (default: 67)
    * `:config` - DHCP configuration map
  
  ## Examples
  
      config = DHCP.Config.new!(
        subnet: {192, 168, 1, 0},
        netmask: {255, 255, 255, 0},
        range_start: {192, 168, 1, 100},
        range_end: {192, 168, 1, 200},
        gateway: {192, 168, 1, 1},
        dns_servers: [{8, 8, 8, 8}]
      )
      
      DHCP.Abyss.Handler.start_server(config)
  """
  @spec start_server(DHCP.Config.t() | keyword()) :: {:ok, pid()} | {:error, term()}
  def start_server(config) when is_list(config) do
    case DHCP.Config.new(config) do
      {:ok, config} -> start_server(config)
      {:error, reason} -> {:error, reason}
    end
  end

  def start_server(config) do
    # Note: :abyss is an optional dependency
    if Code.ensure_loaded?(:abyss) do
      :abyss.start_link(
        __MODULE__,
        config,
        name: __MODULE__,
        port: 67,
        broadcast: true
      )
    else
      {:error, ":abyss dependency not available"}
    end
  end

  @doc """
  Get current DHCP server statistics.
  """
  @spec get_stats() :: %{leases: list(), available_ips: integer(), used_ips: integer()}
  def get_stats() do
    case Process.whereis(__MODULE__) do
      nil -> %{leases: [], available_ips: 0, used_ips: 0}
      pid ->
        state = :sys.get_state(pid)
        leases = Server.get_leases(state.server_state)
        
        %{
          leases: leases,
          available_ips: MapSet.size(state.server_state.ip_pool) - MapSet.size(state.server_state.used_ips),
          used_ips: MapSet.size(state.server_state.used_ips)
        }
    end
  end

  @doc """
  Manually expire leases (useful for testing).
  """
  @spec expire_leases() :: :ok
  def expire_leases() do
    case Process.whereis(__MODULE__) do
      nil -> :ok
      pid -> send(pid, :expire_leases)
    end
  end
end