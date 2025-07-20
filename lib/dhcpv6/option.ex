defmodule DHCPv6.Option do
  @moduledoc """
  DHCPv6 option parsing and construction according to RFC 3315.
  """

  @type t :: %__MODULE__{
          option_code: integer(),
          option_data: binary()
        }

  defstruct [
    :option_code,
    :option_data
  ]


  @doc """
  Create a new DHCPv6 option.
  """
  @spec new(integer(), binary()) :: t()
  def new(option_code, option_data) do
    %__MODULE__{
      option_code: option_code,
      option_data: option_data
    }
  end

  @doc """
  Parse DHCPv6 option from binary.
  """
  @spec parse_option(binary()) :: {:ok, t(), binary()} | {:error, String.t()}
  def parse_option(<<option_code::16, option_length::16, option_data::binary-size(option_length), rest::binary>>) do
    {:ok, %__MODULE__{option_code: option_code, option_data: option_data}, rest}
  end

  def parse_option(_), do: {:error, "Invalid DHCPv6 option format"}

  @doc """
  Convert DHCPv6 option to binary.
  """
  @spec to_iodata(t()) :: binary()
  def to_iodata(option) do
    option_length = byte_size(option.option_data)
    <<option.option_code::16, option_length::16, option.option_data::binary>>
  end

  @doc """
  Create IA_NA option (Identity Association for Non-temporary Addresses).
  """
  @spec ia_na(integer(), integer(), integer(), [:inet.ip6_address()]) :: t()
  def ia_na(iaid, t1, t2, addresses) do
    iaid_bin = <<iaid::32>>
    t1_bin = <<t1::32>>
    t2_bin = <<t2::32>>
    
    iaaddr_options = Enum.map(addresses, fn addr ->
      addr_bin = ip6_to_binary(addr)
      iaaddr_opt = new(5, addr_bin)  # IAADDR option
      to_iodata(iaaddr_opt)
    end) |> Enum.join()
    
    ia_na_data = <<iaid_bin::binary, t1_bin::binary, t2_bin::binary, iaaddr_options::binary>>
    new(3, ia_na_data)  # IA_NA option code
  end

  @doc """
  Create DNS servers option.
  """
  @spec dns_servers([:inet.ip6_address()]) :: t()
  def dns_servers(servers) do
    server_data = Enum.map(servers, &ip6_to_binary/1) |> Enum.join()
    new(23, server_data)
  end

  defp ip6_to_binary({a, b, c, d, e, f, g, h}) do
    <<a::16, b::16, c::16, d::16, e::16, f::16, g::16, h::16>>
  end
end