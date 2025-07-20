#!/usr/bin/env elixir

# Basic DHCP Server Example
# Run with: elixir examples/basic_server.exs

# Mix.install([:abyss])  # Not needed in Mix project

alias DHCP.Config
alias DHCP.Abyss.Handler

# Create DHCP configuration
config = Config.new!(
  subnet: {192, 168, 1, 0},
  netmask: {255, 255, 255, 0},
  range_start: {192, 168, 1, 100},
  range_end: {192, 168, 1, 200},
  gateway: {192, 168, 1, 1},
  dns_servers: [
    {8, 8, 8, 8},
    {8, 8, 4, 4}
  ],
  lease_time: 3600  # 1 hour
)

# Start the DHCP server
{:ok, _pid} = Handler.start_server(config)

IO.puts("DHCP Server started on port 67")
IO.puts("Network: 192.168.1.0/24")
IO.puts("IP Range: 192.168.1.100 - 192.168.1.200")
IO.puts("Gateway: 192.168.1.1")
IO.puts("DNS: 8.8.8.8, 8.8.4.4")
IO.puts("\nPress Ctrl+C to stop the server")

# Keep the process alive
Process.sleep(:infinity)