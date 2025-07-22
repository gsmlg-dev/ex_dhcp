defmodule DHCPv4 do
  @moduledoc """
  Dynamic Host Configuration Protocol

  [RFC2131](https://datatracker.ietf.org/doc/html/rfc2131)

  The Dynamic Host Configuration Protocol (DHCP) provides configuration
  parameters to Internet hosts.  DHCP consists of two components: a
  protocol for delivering host-specific configuration parameters from a
  DHCP server to a host and a mechanism for allocation of network
  addresses to hosts.

  DHCP is built on a client-server model, where designated DHCP server
  hosts allocate network addresses and deliver configuration parameters
  to dynamically configured hosts.  Throughout the remainder of this
  document, the term "server" refers to a host providing initialization
  parameters through DHCP, and the term "client" refers to a host
  requesting initialization parameters from a DHCP server.

  """
  def to_iodata(value) do
    DHCPv4.Parameter.to_iodata(value)
  end
end
