import Config

# Example DHCP server configuration

# Basic network configuration
config :dhcp_ex, :server,
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

# Alternative configuration for a different network
# config :dhcp_ex, :server,
#   subnet: {10, 0, 0, 0},
#   netmask: {255, 255, 255, 0},
#   range_start: {10, 0, 0, 50},
#   range_end: {10, 0, 0, 150},
#   gateway: {10, 0, 0, 1},
#   dns_servers: [{1, 1, 1, 1}, {1, 0, 0, 1}],
#   lease_time: 7200  # 2 hours

# Development configuration (smaller range)
# config :dhcp_ex, :server,
#   subnet: {192, 168, 56, 0},
#   netmask: {255, 255, 255, 0},
#   range_start: {192, 168, 56, 10},
#   range_end: {192, 168, 56, 20},
#   gateway: {192, 168, 56, 1},
#   dns_servers: [{192, 168, 56, 1}],
#   lease_time: 300  # 5 minutes