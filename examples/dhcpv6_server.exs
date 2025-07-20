#!/usr/bin/env elixir

# DHCPv6 Server Example
# Run with: mix run examples/dhcpv6_server.exs

defmodule DHCPv6ServerExample do
  alias DHCPv6.Config
  alias DHCPv6.Server
  alias DHCPv6.Client

  def run do
    # Create DHCPv6 configuration
    config = Config.new!(
      prefix: {0x2001, 0x0DB8, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
      prefix_length: 64,
      range_start: {0x2001, 0x0DB8, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x1000},
      range_end: {0x2001, 0x0DB8, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xFFFF},
      dns_servers: [
        {0x2001, 0x4860, 0x4860, 0, 0, 0, 0, 0x8888},
        {0x2001, 0x4860, 0x4860, 0, 0, 0, 0, 0x8844}
      ],
      lease_time: 3600,  # 1 hour
      rapid_commit: false
    )

    # Initialize server state
    state = Server.init(config)

    IO.puts("=== DHCPv6 Server Test ===")
    IO.puts("IPv6 Prefix: 2001:db8::/64")
    IO.puts("IP Range: 2001:db8::1000 - 2001:db8::ffff")
    IO.puts("DNS Servers: 2001:4860:4860::8888, 2001:4860:4860::8844")
    IO.puts("Lease Time: #{config.lease_time} seconds")
    IO.puts("Rapid Commit: #{config.rapid_commit}")

    # Test client simulation
    duid = "test-client-duid"
    iaid = 12345

    IO.puts("\nTesting DHCPv6 lease cycle...")
    IO.puts("Client DUID: #{duid}")
    IO.puts("IAID: #{iaid}")

    # Simulate SOLICIT
    solicit_msg = Client.solicit(duid: duid, iaid: iaid)
    IO.puts("\n1. SOLICIT message created")

    # Process SOLICIT and get ADVERTISE
    {state_after_advertise, advertise_msgs} = Server.process_message(state, solicit_msg, {0, 0, 0, 0, 0, 0, 0, 0}, 0)
    IO.puts("2. ADVERTISE received:")
    advertise_msg = if is_list(advertise_msgs), do: List.first(advertise_msgs), else: advertise_msgs
    IO.inspect(advertise_msg, limit: :infinity)

    # Simulate REQUEST
    addresses = extract_addresses(advertise_msg)
    request_msg = Client.request(
      duid: duid,
      server_duid: "test-server-duid",
      iaid: iaid,
      addresses: addresses
    )
    IO.puts("\n3. REQUEST message created for addresses: #{inspect(addresses)}")

    # Process REQUEST and get REPLY
    {state_after_reply, reply_msgs} = Server.process_message(state_after_advertise, request_msg, {0, 0, 0, 0, 0, 0, 0, 0}, 0)
    IO.puts("4. REPLY received:")
    reply_msg = if is_list(reply_msgs), do: List.first(reply_msgs), else: reply_msgs
    IO.inspect(reply_msg, limit: :infinity)

    # Show current leases
    leases = Server.get_leases(state_after_reply)
    IO.puts("\n5. Current leases:")
    Enum.each(leases, fn lease ->
      IO.puts("  IP: #{format_ipv6(lease.ip)} assigned to #{lease.duid} (expires at #{lease.expires_at})")
    end)

    # Test RELEASE
    release_msg = Client.release(
      duid: duid,
      server_duid: "test-server-duid",
      iaid: iaid,
      addresses: addresses
    )
    IO.puts("\n6. RELEASE message created")

    # Process RELEASE
    {state_after_release, release_replies} = Server.process_message(state_after_reply, release_msg, {0, 0, 0, 0, 0, 0, 0, 0}, 0)
    IO.puts("7. RELEASE REPLY received:")
    release_reply = if is_list(release_replies), do: List.first(release_replies), else: release_replies
    IO.inspect(release_reply, limit: :infinity)

    # Show remaining leases
    leases_after_release = Server.get_leases(state_after_release)
    IO.puts("\n8. Remaining leases after release: #{length(leases_after_release)}")

    IO.puts("\nDHCPv6 test completed successfully!")
  end

  ## Helper functions

  defp extract_addresses(message) do
    message.options
    |> Enum.filter(&(&1.option_code == 3))  # IA_NA
    |> Enum.flat_map(fn option ->
      <<_iaid::32, _t1::32, _t2::32, rest::binary>> = option.option_data
      parse_ia_addresses(rest)
    end)
  end

  defp parse_ia_addresses(data) do
    parse_ia_addresses(data, [])
  end

  defp parse_ia_addresses(<<>>, acc), do: Enum.reverse(acc)
  defp parse_ia_addresses(
    <<5::16, option_length::16, addr_data::binary-size(option_length), rest::binary>>, acc) do
    case parse_ipv6_address(addr_data) do
      {:ok, addr} -> parse_ia_addresses(rest, [addr | acc])
      {:error, _} -> parse_ia_addresses(rest, acc)
    end
  end
  defp parse_ia_addresses(_, acc), do: Enum.reverse(acc)

  defp parse_ipv6_address(<<a::16, b::16, c::16, d::16, e::16, f::16, g::16, h::16>>) do
    {:ok, {a, b, c, d, e, f, g, h}}
  end
  defp parse_ipv6_address(_), do: {:error, "Invalid IPv6 address"}

  defp format_ipv6({a, b, c, d, e, f, g, h}) do
    :inet.ntoa({a, b, c, d, e, f, g, h})
  end
end

# Run the example
DHCPv6ServerExample.run()