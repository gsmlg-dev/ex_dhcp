defmodule DHCP.Message.Option do
  @moduledoc """
  # DHCP Option

  DHCP Options and BOOTP Vendor Extensions [RFC2132](https://datatracker.ietf.org/doc/html/rfc2132)

  magic cookie [link](https://datatracker.ietf.org/doc/html/rfc2132#section-2)

  When used with BOOTP, the first four octets of the vendor information
  field have been assigned to the "magic cookie" (as suggested in RFC
  951).  This field identifies the mode in which the succeeding data is
  to be interpreted.  The value of the magic cookie is the 4 octet
  dotted decimal 99.130.83.99 (or hexadecimal number 63.82.53.63) in
  network byte order.

   Pad Option

   The pad option can be used to cause subsequent fields to align on
   word boundaries.

   The code for the pad option is 0, and its length is 1 octet.

        Code
      +-----+
      |  0  |
      +-----+

   End Option

   The end option marks the end of valid information in the vendor
   field.  Subsequent octets should be filled with pad options.

   The code for the end option is 255, and its length is 1 octet.

        Code
      +-----+
      | 255 |
      +-----+

  """
  alias DHCP.Message.Option

  @type t :: %__MODULE__{
          type: 0..255,
          length: 0..255,
          value: bitstring()
        }

  defstruct type: nil, length: nil, value: nil

  @magic_cookie <<99, 130, 83, 99>>

  # @pad_option 0x00
  @end_option 0xFF

  def new(type, length, value) do
    %__MODULE__{
      type: type,
      length: length,
      value: value
    }
  end

  def from_binary(<<type::8, length::8, value::binary-size(length)>>) do
    new(type, length, value)
  end

  def parse(data), do: parse_dhcp_options(data)

  defp parse_dhcp_options(<<>>), do: []
  defp parse_dhcp_options(<<@magic_cookie::binary, rest::binary>>), do: parse_options(rest)

  defp parse_dhcp_options(_),
    do:
      throw(
        {:parse_dhcp_options_failed,
         "dhcp options must start with magic cookie #{@magic_cookie |> inspect}"}
      )

  # End Option
  defp parse_options(<<@end_option, _rest::binary>>), do: []

  defp parse_options(<<code, length, value::binary-size(length), rest::binary>>) do
    [new(code, length, value) | parse_options(rest)]
  end

  def to_dhcp_binary(options) do
    options_binary =
      options |> Enum.map(fn opt -> DHCP.Parameter.to_binary(opt) end) |> Enum.join(<<>>)

    <<@magic_cookie::binary, options_binary::binary, @end_option>>
  end

  def decode_option_value(type, length, value) do
    case type do
      1 ->
        {"Subnet Mask", :ip, value |> to_ip_address()}
      2 ->
        {"Time Offset", :int, value |> to_int(32)}
      3 ->
        {"Router", :ip_list, value |> to_ip_address_list(length)}
      4 ->
        {"Time Server", :ip_list, value |> to_ip_address_list(length)}
      5 ->
        {"Name Server", :ip_list, value |> to_ip_address_list(length)}
      6 ->
        {"Domain Name Server", :ip_list, value |> to_ip_address_list(length)}
      7 ->
        {"Log Server", :ip_list, value |> to_ip_address_list(length)}
      8 ->
        {"Cookie Server", :ip_list, value |> to_ip_address_list(length)}
      9 ->
        {"LPR Server", :ip_list, value |> to_ip_address_list(length)}
      10 ->
        {"Impress Server", :ip_list, value |> to_ip_address_list(length)}
      11 ->
        {"Resource Location Server", :ip_list, value |> to_ip_address_list(length)}
      12 ->
        {"Host Name", :binary, value |> to_string()}
      13 ->
        {"Boot File Size", :int, value |> to_int(16)}
      14 ->
        {"Merit Dump File", :binary, value |> to_string()}
      15 ->
        {"Domain Name", :binary, value |> to_string()}
      16 ->
        {"Swap Server", :ip, value |> to_ip_address()}
      17 ->
        {"Root Path", :binary, value |> to_string()}
      18 ->
        {"Extensions Path", :binary, value |> to_string()}
      19 ->
        {"IP Forwarding Enable/Disable", :bool, value |> to_bool()}
      20 ->
        {"Non-Local Source Routing Enable/Disable", :bool, value |> to_bool()}
      21 ->
        {"Policy Filter", :ip_mask_list, value |> to_ip_mask_list(length)}
      22 ->
        {"Maximum Datagram Reassembly Size", :int, value |> to_int(16)}
      23 ->
        {"Default IP Time-to-Live", :int, value |> to_int(8)}
      24 ->
        {"Path MTU Aging Timeout", :int, value |> to_int(32)}
      25 ->
        {"Path MTU Plateau Table", :int_list, value |> to_int_list(16, length)}
      26 ->
        {"Interface MTU", :int, value |> to_int(16)}
      27 ->
        {"All Subnets are Local", :bool, value |> to_bool()}
      28 ->
        {"Broadcast Address", :ip, value |> to_ip_address()}
      29 ->
        {"Perform Mask Discovery", :bool, value |> to_bool()}
      30 ->
        {"Mask Supplier", :bool, value |> to_bool()}
      31 ->
        {"Perform Router Discovery", :bool, value |> to_bool()}
      32 ->
        {"Router Solicitation Address", :ip, value |> to_ip_address()}
      33 ->
        {"Static Route", :ip_mask_list, value |> to_ip_mask_list(length)}
      34 ->
        {"Trailer Encapsulation", :bool, value |> to_bool()}
      35 ->
        {"ARP Cache Timeout", :int, value |> to_int(32)}
      36 ->
        {"Ethernet Encapsulation", :bool, value |> to_bool()}
      37 ->
        {"TCP Default TTL", :int, value |> to_int(8)}
      38 ->
        {"TCP Keepalive Interval", :int, value |> to_int(32)}
      39 ->
        {"TCP Keepalive Garbage", :bool, value |> to_bool()}
      40 ->
        {"Network Information Service Domain", :binary, value |> to_string()}
      41 ->
        {"Network Information Servers", :ip_list, value |> to_ip_address_list(length)}
      42 ->
        {"NTP Servers", :ip_list, value |> to_ip_address_list(length)}
      43 ->
        {"Vendor Specific Information", :binary, value |> to_string()}
      44 ->
        {"NetBIOS over TCP/IP Name Server", :ip_list, value |> to_ip_address_list(length)}
      45 ->
        {"NetBIOS over TCP/IP Datagram Distribution Server", :ip_list, value |> to_ip_address_list(length)}
      46 ->
        {"NetBIOS over TCP/IP Node Type", :int, value |> to_int(8)}
      47 ->
        {"NetBIOS over TCP/IP Scope", :binary, value |> to_string()}
      48 ->
        {"X Window System Font Server", :ip_list, value |> to_ip_address_list(length)}
      49 ->
        {"X Window System Display Manager", :ip_list, value |> to_ip_address_list(length)}
      50 ->
        {"Requested IP Address", :ip, value |> to_ip_address()}
      51 ->
        {"IP Address Lease Time", :int, value |> to_int(32)}
      52 ->
        {"Option Overload", :int, value |> to_int(8)}
      53 ->
        message_types = [
        {1, "DHCPDISCOVER", "Client broadcast to locate available servers"},
        {2, "DHCPOFFER", "Server offers an IP address to the client"},
        {3, "DHCPREQUEST", "Client requests offered IP or renews lease"},
        {4, "DHCPDECLINE", "Client declines the offered IP"},
        {5, "DHCPACK", "Server acknowledges the IP lease"},
        {6, "DHCPNAK", "Server refuses the IP request"},
        {7, "DHCPRELEASE", "Client releases the leased IP"},
        {8, "DHCPINFORM", "Client requests configuration without an IP"},
        ]
        type_int = value |> to_int(8)
        message = Enum.find_value(message_types, type_int, fn {id, type_message, desc} ->
          if id == type_int do
            type_message <> " - " <> desc
          else
            false
          end
        end)
        {"DHCP Message Type", :binary, message}
      54 ->
        {"Server Identifier", :ip, value |> to_ip_address()}
      55 ->
        {"Parameter Request List", :int_list, value |> to_int_list(8, length)}
      56 ->
        {"Message", :binary, value |> to_string()}
      57 ->
        {"Maximum DHCP Message Size", :int, value |> to_int(16)}
      58 ->
        {"Renewal (T1) Time Value", :int, value |> to_int(32)}
      59 ->
        {"Rebinding (T2) Time Value", :int, value |> to_int(32)}
      60 ->
        {"Vendor class identifier", :int_list, value |> to_int_list(8, length)}
      61 ->
        {"Client-identifier", :binary, value |> to_string()}
      62 ->
        {"Netware/IP Domain Name", :binary, value |> to_string()}
      63 ->
        {"Netware/IP sub Options", :binary, value |> to_string()}
      64 ->
        {"NIS+ Domain", :binary, value |> to_string()}
      65 ->
        {"NIS+ Servers", :ip_list, value |> to_ip_address_list(length)}
      68 ->
        {"Mobile IP Home Agent", :ip_list, value |> to_ip_address_list(length)}
      69 ->
        {"SMTP Server", :ip_list, value |> to_ip_address_list(length)}
      70 ->
        {"POP3 Server", :ip_list, value |> to_ip_address_list(length)}
      71 ->
        {"NNTP Server", :ip_list, value |> to_ip_address_list(length)}
      72 ->
        {"WWW Server", :ip_list, value |> to_ip_address_list(length)}
      73 ->
        {"Finger Server", :ip_list, value |> to_ip_address_list(length)}
      74 ->
        {"IRC Server", :ip_list, value |> to_ip_address_list(length)}
      75 ->
        {"StreetTalk Server", :ip_list, value |> to_ip_address_list(length)}
      76 ->
        {"StreetTalk Directory Assistance Server", :ip_list, value |> to_ip_address_list(length)}
      100 ->
        {"TZ-POSIX String", :binary, value |> to_string()}
      101 ->
        {"TZ-Database String", :binary, value |> to_string()}
      121 ->
        {"Classless Static Route Option", :network_mask_router_list, value |> to_mask_network_route_list(length)}
      _ ->
        {"Unknown", :raw, value}
    end
  end

  defp to_ip_mask_list(<<a::8, b::8, c::8, d::8, e::8, f::8, g::8, h::8, rest::binary>>, len) do
    if len - 8 == 0 do
      [{{a, b, c, d}, {e, f, g, h}}]
    else
      [{{a, b, c, d}, {e, f, g, h}} | to_ip_mask_list(rest, len - 8)]
    end
  end
  defp to_ip_address_list(<<a::8, b::8, c::8, d::8, rest::binary>>, len) do
    if len - 4 == 0 do
      [{a, b, c, d}]
    else
      [{a, b, c, d} | to_ip_address_list(rest, len - 4)]
    end
  end
  defp to_ip_address(<<a::8, b::8, c::8, d::8>>) do
    {a, b, c, d}
  end
  defp to_int(int, b) do
    <<a::size(b)>> = int
    a
  end
  defp to_bool(<<val::8>>) do
    val == 1 || false
  end
  defp to_int_list(int, b, len) do
    <<a::size(b), rest::binary>> = int
    if len - b / 8 == 0 do
      [a]
    else
      [a | to_int_list(rest, b, len - b / 8)]
    end
  end
  defp to_mask_network_route_list(_bin, len) when len == 0, do: []
  defp to_mask_network_route_list(bin, len) do
    <<mask::8, rest::binary>> = bin
    {network, router, rest, size} = case mask do
      0 ->
        <<router::binary-size(4), rest::binary>> = rest
        {{0,0,0,0}, router, rest, 5}
      n when n >= 1 and n <= 8 ->
        <<a::8, router::binary-size(4), rest::binary>> = rest
        {{a,0,0,0}, router, rest, 6}
      n when n >= 9 and n <= 16 ->
        <<a::8, b::8, router::binary-size(4), rest::binary>> = rest
        {{a,b,0,0}, router, rest, 7}
      n when n >= 17 and n <= 24 ->
        <<a::8, b::8, c::8, router::binary-size(4), rest::binary>> = rest
        {{a,b,c,0}, router, rest, 8}
      n when n >= 25 and n <= 32 ->
        <<a::8, b::8, c::8, d::8, router::binary-size(4), rest::binary>> = rest
        {{a,b,c,d}, router, rest, 9}
    end
    [{network, mask, router} | to_mask_network_route_list(rest, len - size)]
  end

  defimpl DHCP.Parameter, for: Option do
    @impl true
    def to_binary(%Option{} = option) do
      <<option.type::8, option.length::8, option.value::binary-size(option.length)>>
    end
  end

  defimpl String.Chars, for: Option do
    def to_string(%Option{} = option) do
      decoded_value = Option.decode_option_value(option.type, option.length, option.value)
      """
      Option(#{option.type}): #{parse_decoded_value(decoded_value)})}
      """
    end

    def parse_decoded_value({name, type, value}) do
      case type do
        :ip ->
          "#{name}: #{value |> :inet.ntoa()}"
        :ip_list ->
          "#{name}: #{value |> Enum.map(fn ip -> ip |> :inet.ntoa() end) |> Enum.join(", ")}"
        :ip_mask_list ->
          "#{name}: #{value |> Enum.map(fn {ip, mask} -> "#{ip |> :inet.ntoa()}/#{mask |> :inet.ntoa()}" end) |> Enum.join(", ")}"
        :network_mask_router_list ->
          "#{name}: #{value |> Enum.map(fn {network, mask, router} -> "#{network |> :inet.ntoa()}/#{mask} via #{router |> :inet.ntoa()}" end) |> Enum.join(", ")}"
        :int_list ->
          "#{name}: #{value |> Enum.map(fn int -> "#{int}" end) |> Enum.join(", ")}"
        :int ->
          "#{name}: #{value}"
        :bool ->
          "#{name}: #{value}"
        :binary ->
          "#{name}: #{value}"
        :raw ->
          "#{name}: #{value |> inspect()}"
      end
    end
  end
end
