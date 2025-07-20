#!/usr/bin/env elixir

# DHCP Client Test Example
# Run with: elixir examples/test_client.exs

# Mix.install([:dhcp_ex])  # Not needed in Mix project

alias DHCP.Client

IO.puts("=== DHCP Client Test ===")

# Test MAC address
mac = "AABBCCDDEEFF" |> Base.decode16!()

IO.puts("Testing DHCP lease cycle...")
IO.puts("Client MAC: #{Base.encode16(mac, case: :lower)}")

# Test lease cycle
case Client.test_lease_cycle(mac: mac) do
  {:ok, result} ->
    IO.puts("\n✅ DHCP lease cycle successful!")
    IO.puts("Discover: #{inspect(result.discover)}")
    IO.puts("Offer: #{result.offer.yiaddr |> :inet.ntoa()}")
    IO.puts("Request: #{inspect(result.request)}")
    IO.puts("ACK: #{result.ack.yiaddr |> :inet.ntoa()}")
    
    IO.puts("\nDHCP Options:")
    Enum.each(result.ack.options, fn opt ->
      {name, _type, value} = DHCP.Message.Option.decode_option_value(opt.type, opt.length, opt.value)
      IO.puts("  #{name}: #{inspect(value)}")
    end)
    
  {:error, reason} ->
    IO.puts("❌ DHCP lease cycle failed: #{inspect(reason)}")
    
    # Try individual steps for debugging
    IO.puts("\nTesting individual steps...")
    
    discover_msg = Client.discover(mac: mac)
    IO.puts("Discover message: #{inspect(discover_msg)}")
    
    case Client.send_message(message: discover_msg) do
      {:ok, offer} ->
        IO.puts("Offer received: #{offer.yiaddr |> :inet.ntoa()}")
        
        request_msg = Client.request(
          mac: mac,
          server_ip: {192, 168, 1, 1},  # Assuming server IP
          requested_ip: offer.yiaddr
        )
        
        case Client.send_message(message: request_msg) do
          {:ok, ack} ->
            IO.puts("ACK received: #{ack.yiaddr |> :inet.ntoa()}")
          {:error, reason} ->
            IO.puts("Request failed: #{inspect(reason)}")
        end
        
      {:error, reason} ->
        IO.puts("Discover failed: #{inspect(reason)}")
    end
end