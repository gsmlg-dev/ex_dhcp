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

  **Subnet Mask**

   The subnet mask option specifies the client's subnet mask as per RFC
   950 [5].

   If both the subnet mask and the router option are specified in a DHCP
   reply, the subnet mask option MUST be first.

   The code for the subnet mask option is 1, and its length is 4 octets.

        Code   Len        Subnet Mask
      +-----+-----+-----+-----+-----+-----+
      |  1  |  4  |  m1 |  m2 |  m3 |  m4 |
      +-----+-----+-----+-----+-----+-----+

  **Time Offset**

   The time offset field specifies the offset of the client's subnet in
   seconds from Coordinated Universal Time (UTC).  The offset is
   expressed as a two's complement 32-bit integer.  A positive offset
   indicates a location east of the zero meridian and a negative offset
   indicates a location west of the zero meridian.

   The code for the time offset option is 2, and its length is 4 octets.

        Code   Len        Time Offset
      +-----+-----+-----+-----+-----+-----+
      |  2  |  4  |  n1 |  n2 |  n3 |  n4 |
      +-----+-----+-----+-----+-----+-----+

  **Router Option**

   The router option specifies a list of IP addresses for routers on the
   client's subnet.  Routers SHOULD be listed in order of preference.

   The code for the router option is 3.  The minimum length for the
   router option is 4 octets, and the length MUST always be a multiple
   of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  3  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Time Server Option**

   The time server option specifies a list of RFC 868 [6] time servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for the time server option is 4.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  4  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Name Server Option**

   The name server option specifies a list of IEN 116 [7] name servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for the name server option is 5.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  5  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Domain Name Server Option**

   The domain name server option specifies a list of Domain Name System
   (STD 13, RFC 1035 [8]) name servers available to the client.  Servers
   SHOULD be listed in order of preference.

   The code for the domain name server option is 6.  The minimum length
   for this option is 4 octets, and the length MUST always be a multiple
   of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  6  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Log Server Option**

   The log server option specifies a list of MIT-LCS UDP log servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for the log server option is 7.  The minimum length for this
   option is 4 octets, and the length MUST always be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  7  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Cookie Server Option**

   The cookie server option specifies a list of RFC 865 [9] cookie
   servers available to the client.  Servers SHOULD be listed in order
   of preference.

   The code for the log server option is 8.  The minimum length for this
   option is 4 octets, and the length MUST always be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  8  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **LPR Server Option**

   The LPR server option specifies a list of RFC 1179 [10] line printer
   servers available to the client.  Servers SHOULD be listed in order
   of preference.

   The code for the LPR server option is 9.  The minimum length for this
   option is 4 octets, and the length MUST always be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  9  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
        +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Impress Server Option**

   The Impress server option specifies a list of Imagen Impress servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for the Impress server option is 10.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  10 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Resource Location Server Option**

   This option specifies a list of RFC 887 [11] Resource Location
   servers available to the client.  Servers SHOULD be listed in order
   of preference.

   The code for this option is 11.  The minimum length for this option
   is 4 octets, and the length MUST always be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  11 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Host Name Option**

   This option specifies the name of the client.  The name may or may
   not be qualified with the local domain name (see section 3.17 for the
   preferred way to retrieve the domain name).  See RFC 1035 for
   character set restrictions.

   The code for this option is 12, and its minimum length is 1.

        Code   Len                 Host Name
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  12 |  n  |  h1 |  h2 |  h3 |  h4 |  h5 |  h6 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Boot File Size Option**

   This option specifies the length in 512-octet blocks of the default
   boot image for the client.  The file length is specified as an
   unsigned 16-bit integer.

   The code for this option is 13, and its length is 2.

        Code   Len   File Size
      +-----+-----+-----+-----+
      |  13 |  2  |  l1 |  l2 |
      +-----+-----+-----+-----+

  **Merit Dump File**

   This option specifies the path-name of a file to which the client's
   core image should be dumped in the event the client crashes.  The
   path is formatted as a character string consisting of characters from
   the NVT ASCII character set.

   The code for this option is 14.  Its minimum length is 1.

        Code   Len      Dump File Pathname
      +-----+-----+-----+-----+-----+-----+---
      |  14 |  n  |  n1 |  n2 |  n3 |  n4 | ...
      +-----+-----+-----+-----+-----+-----+---

  **Domain Name**

   This option specifies the domain name that client should use when
   resolving hostnames via the Domain Name System.

   The code for this option is 15.  Its minimum length is 1.

        Code   Len        Domain Name
      +-----+-----+-----+-----+-----+-----+--
      |  15 |  n  |  d1 |  d2 |  d3 |  d4 |  ...
      +-----+-----+-----+-----+-----+-----+--

  **Swap Server**

   This specifies the IP address of the client's swap server.

   The code for this option is 16 and its length is 4.

        Code   Len    Swap Server Address
      +-----+-----+-----+-----+-----+-----+
      |  16 |  n  |  a1 |  a2 |  a3 |  a4 |
      +-----+-----+-----+-----+-----+-----+

  **Root Path**

   This option specifies the path-name that contains the client's root
   disk.  The path is formatted as a character string consisting of
   characters from the NVT ASCII character set.

   The code for this option is 17.  Its minimum length is 1.

        Code   Len      Root Disk Pathname
      +-----+-----+-----+-----+-----+-----+---
      |  17 |  n  |  n1 |  n2 |  n3 |  n4 | ...
      +-----+-----+-----+-----+-----+-----+---

  **Extensions Path**

   A string to specify a file, retrievable via TFTP, which contains
   information which can be interpreted in the same way as the 64-octet
   vendor-extension field within the BOOTP response, with the following
   exceptions:

          - the length of the file is unconstrained;
          - all references to Tag 18 (i.e., instances of the
            BOOTP Extensions Path field) within the file are
            ignored.

   The code for this option is 18.  Its minimum length is 1.

        Code   Len      Extensions Pathname
      +-----+-----+-----+-----+-----+-----+---
      |  18 |  n  |  n1 |  n2 |  n3 |  n4 | ...
      +-----+-----+-----+-----+-----+-----+---

  **IP Forwarding Enable/Disable Option**

   This option specifies whether the client should configure its IP
   layer for packet forwarding.  A value of 0 means disable IP
   forwarding, and a value of 1 means enable IP forwarding.

   The code for this option is 19, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  19 |  1  | 0/1 |
      +-----+-----+-----+

  **Non-Local Source Routing Enable/Disable Option**

   This option specifies whether the client should configure its IP
   layer to allow forwarding of datagrams with non-local source routes
   (see Section 3.3.5 of [4] for a discussion of this topic).  A value
   of 0 means disallow forwarding of such datagrams, and a value of 1
   means allow forwarding.

   The code for this option is 20, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  20 |  1  | 0/1 |
      +-----+-----+-----+

  **Policy Filter Option**

   This option specifies policy filters for non-local source routing.
   The filters consist of a list of IP addresses and masks which specify
   destination/mask pairs with which to filter incoming source routes.

   Any source routed datagram whose next-hop address does not match one
   of the filters should be discarded by the client.

   See [4] for further information.

   The code for this option is 21.  The minimum length of this option is
   8, and the length MUST be a multiple of 8.

        Code   Len         Address 1                  Mask 1
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
      |  21 |  n  |  a1 |  a2 |  a3 |  a4 |  m1 |  m2 |  m3 |  m4 |
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
              Address 2                  Mask 2
      +-----+-----+-----+-----+-----+-----+-----+-----+---
      |  a1 |  a2 |  a3 |  a4 |  m1 |  m2 |  m3 |  m4 | ...
      +-----+-----+-----+-----+-----+-----+-----+-----+---

  **Maximum Datagram Reassembly Size**

   This option specifies the maximum size datagram that the client
   should be prepared to reassemble.  The size is specified as a 16-bit
   unsigned integer.  The minimum value legal value is 576.

   The code for this option is 22, and its length is 2.

        Code   Len      Size
      +-----+-----+-----+-----+
      |  22 |  2  |  s1 |  s2 |
      +-----+-----+-----+-----+

  **Default IP Time-to-live**

   This option specifies the default time-to-live that the client should
   use on outgoing datagrams.  The TTL is specified as an octet with a
   value between 1 and 255.

   The code for this option is 23, and its length is 1.

        Code   Len   TTL
      +-----+-----+-----+
      |  23 |  1  | ttl |
      +-----+-----+-----+

  **Path MTU Aging Timeout Option**

   This option specifies the timeout (in seconds) to use when aging Path
   MTU values discovered by the mechanism defined in RFC 1191 [12].  The
   timeout is specified as a 32-bit unsigned integer.

   The code for this option is 24, and its length is 4.

        Code   Len           Timeout
      +-----+-----+-----+-----+-----+-----+
      |  24 |  4  |  t1 |  t2 |  t3 |  t4 |
      +-----+-----+-----+-----+-----+-----+

  **Path MTU Plateau Table Option**

   This option specifies a table of MTU sizes to use when performing
   Path MTU Discovery as defined in RFC 1191.  The table is formatted as
   a list of 16-bit unsigned integers, ordered from smallest to largest.
   The minimum MTU value cannot be smaller than 68.

   The code for this option is 25.  Its minimum length is 2, and the
   length MUST be a multiple of 2.

        Code   Len     Size 1      Size 2
      +-----+-----+-----+-----+-----+-----+---
      |  25 |  n  |  s1 |  s2 |  s1 |  s2 | ...
      +-----+-----+-----+-----+-----+-----+---

  **IP Layer Parameters per Interface**

   This section details the options that affect the operation of the IP
   layer on a per-interface basis.  It is expected that a client can
   issue multiple requests, one per interface, in order to configure
   interfaces with their specific parameters.

  **Interface MTU Option**

   This option specifies the MTU to use on this interface.  The MTU is
   specified as a 16-bit unsigned integer.  The minimum legal value for
   the MTU is 68.

   The code for this option is 26, and its length is 2.

        Code   Len      MTU
      +-----+-----+-----+-----+
      |  26 |  2  |  m1 |  m2 |
      +-----+-----+-----+-----+

  **All Subnets are Local Option**

   This option specifies whether or not the client may assume that all
   subnets of the IP network to which the client is connected use the
   same MTU as the subnet of that network to which the client is
   directly connected.  A value of 1 indicates that all subnets share
   the same MTU.  A value of 0 means that the client should assume that
   some subnets of the directly connected network may have smaller MTUs.

   The code for this option is 27, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  27 |  1  | 0/1 |
      +-----+-----+-----+

  **Broadcast Address Option**

   This option specifies the broadcast address in use on the client's
   subnet.  Legal values for broadcast addresses are specified in
   section 3.2.1.3 of [4].

   The code for this option is 28, and its length is 4.

        Code   Len     Broadcast Address
      +-----+-----+-----+-----+-----+-----+
      |  28 |  4  |  b1 |  b2 |  b3 |  b4 |
      +-----+-----+-----+-----+-----+-----+

  **Perform Mask Discovery Option**

   This option specifies whether or not the client should perform subnet
   mask discovery using ICMP.  A value of 0 indicates that the client
   should not perform mask discovery.  A value of 1 means that the
   client should perform mask discovery.

   The code for this option is 29, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  29 |  1  | 0/1 |
      +-----+-----+-----+

  **Mask Supplier Option**

   This option specifies whether or not the client should respond to
   subnet mask requests using ICMP.  A value of 0 indicates that the
   client should not respond.  A value of 1 means that the client should
   respond.

   The code for this option is 30, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  30 |  1  | 0/1 |
      +-----+-----+-----+

  **Perform Router Discovery Option**

   This option specifies whether or not the client should solicit
   routers using the Router Discovery mechanism defined in RFC 1256
   [13].  A value of 0 indicates that the client should not perform
   router discovery.  A value of 1 means that the client should perform
   router discovery.

   The code for this option is 31, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  31 |  1  | 0/1 |
      +-----+-----+-----+

  **Router Solicitation Address Option**

   This option specifies the address to which the client should transmit
   router solicitation requests.

   The code for this option is 32, and its length is 4.

        Code   Len            Address
      +-----+-----+-----+-----+-----+-----+
      |  32 |  4  |  a1 |  a2 |  a3 |  a4 |
      +-----+-----+-----+-----+-----+-----+

  **Static Route Option**

   This option specifies a list of static routes that the client should
   install in its routing cache.  If multiple routes to the same
   destination are specified, they are listed in descending order of
   priority.

   The routes consist of a list of IP address pairs.  The first address
   is the destination address, and the second address is the router for
   the destination.

   The default route (0.0.0.0) is an illegal destination for a static
   route.  See section 3.5 for information about the router option.

   The code for this option is 33.  The minimum length of this option is
   8, and the length MUST be a multiple of 8.

        Code   Len         Destination 1           Router 1
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
      |  33 |  n  |  d1 |  d2 |  d3 |  d4 |  r1 |  r2 |  r3 |  r4 |
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
              Destination 2           Router 2
      +-----+-----+-----+-----+-----+-----+-----+-----+---
      |  d1 |  d2 |  d3 |  d4 |  r1 |  r2 |  r3 |  r4 | ...
      +-----+-----+-----+-----+-----+-----+-----+-----+---

  **Trailer Encapsulation Option**

   This option specifies whether or not the client should negotiate the
   use of trailers (RFC 893 [14]) when using the ARP protocol.  A value
   of 0 indicates that the client should not attempt to use trailers.  A
   value of 1 means that the client should attempt to use trailers.

   The code for this option is 34, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  34 |  1  | 0/1 |
      +-----+-----+-----+

  **ARP Cache Timeout Option**

   This option specifies the timeout in seconds for ARP cache entries.
   The time is specified as a 32-bit unsigned integer.

   The code for this option is 35, and its length is 4.

        Code   Len           Time
      +-----+-----+-----+-----+-----+-----+
      |  35 |  4  |  t1 |  t2 |  t3 |  t4 |
      +-----+-----+-----+-----+-----+-----+

  **Ethernet Encapsulation Option**

   This option specifies whether or not the client should use Ethernet
   Version 2 (RFC 894 [15]) or IEEE 802.3 (RFC 1042 [16]) encapsulation
   if the interface is an Ethernet.  A value of 0 indicates that the
   client should use RFC 894 encapsulation.  A value of 1 means that the
   client should use RFC 1042 encapsulation.

   The code for this option is 36, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  36 |  1  | 0/1 |
      +-----+-----+-----+

  **TCP Default TTL Option**

   This option specifies the default TTL that the client should use when
   sending TCP segments.  The value is represented as an 8-bit unsigned
   integer.  The minimum value is 1.

   The code for this option is 37, and its length is 1.

        Code   Len   TTL
      +-----+-----+-----+
      |  37 |  1  |  n  |
      +-----+-----+-----+

  **TCP Keepalive Interval Option**

   This option specifies the interval (in seconds) that the client TCP
   should wait before sending a keepalive message on a TCP connection.
   The time is specified as a 32-bit unsigned integer.  A value of zero
   indicates that the client should not generate keepalive messages on
   connections unless specifically requested by an application.

   The code for this option is 38, and its length is 4.

        Code   Len           Time
      +-----+-----+-----+-----+-----+-----+
      |  38 |  4  |  t1 |  t2 |  t3 |  t4 |
      +-----+-----+-----+-----+-----+-----+

  **TCP Keepalive Garbage Option**

   This option specifies the whether or not the client should send TCP
   keepalive messages with a octet of garbage for compatibility with
   older implementations.  A value of 0 indicates that a garbage octet
   should not be sent. A value of 1 indicates that a garbage octet
   should be sent.

   The code for this option is 39, and its length is 1.

        Code   Len  Value
      +-----+-----+-----+
      |  39 |  1  | 0/1 |
      +-----+-----+-----+

  **Network Information Service Domain Option**

   This option specifies the name of the client's NIS [17] domain.  The
   domain is formatted as a character string consisting of characters
   from the NVT ASCII character set.

   The code for this option is 40.  Its minimum length is 1.

        Code   Len      NIS Domain Name
      +-----+-----+-----+-----+-----+-----+---
      |  40 |  n  |  n1 |  n2 |  n3 |  n4 | ...
      +-----+-----+-----+-----+-----+-----+---

  **Network Information Servers Option**

   This option specifies a list of IP addresses indicating NIS servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for this option is 41.  Its minimum length is 4, and the
   length MUST be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  41 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Network Time Protocol Servers Option**

   This option specifies a list of IP addresses indicating NTP [18]
   servers available to the client.  Servers SHOULD be listed in order
   of preference.

   The code for this option is 42.  Its minimum length is 4, and the
   length MUST be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  42 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Vendor Specific Information**

   This option is used by clients and servers to exchange vendor-
   specific information.  The information is an opaque object of n
   octets, presumably interpreted by vendor-specific code on the clients
   and servers.  The definition of this information is vendor specific.
   The vendor is indicated in the vendor class identifier option.
   Servers not equipped to interpret the vendor-specific information
   sent by a client MUST ignore it (although it may be reported).
   Clients which do not receive desired vendor-specific information
   SHOULD make an attempt to operate without it, although they may do so
   (and announce they are doing so) in a degraded mode.

   If a vendor potentially encodes more than one item of information in
   this option, then the vendor SHOULD encode the option using
   "Encapsulated vendor-specific options" as described below:

   The Encapsulated vendor-specific options field SHOULD be encoded as a
   sequence of code/length/value fields of identical syntax to the DHCP
   options field with the following exceptions:

      1) There SHOULD NOT be a "magic cookie" field in the encapsulated
         vendor-specific extensions field.

      2) Codes other than 0 or 255 MAY be redefined by the vendor within
         the encapsulated vendor-specific extensions field, but SHOULD
         conform to the tag-length-value syntax defined in section 2.

      3) Code 255 (END), if present, signifies the end of the
         encapsulated vendor extensions, not the end of the vendor
         extensions field. If no code 255 is present, then the end of
         the enclosing vendor-specific information field is taken as the
         end of the encapsulated vendor-specific extensions field.

   The code for this option is 43 and its minimum length is 1.

      Code   Len   Vendor-specific information
      +-----+-----+-----+-----+---
      |  43 |  n  |  i1 |  i2 | ...
      +-----+-----+-----+-----+---

   When encapsulated vendor-specific extensions are used, the
   information bytes 1-n have the following format:

        Code   Len   Data item        Code   Len   Data item       Code
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
      |  T1 |  n  |  d1 |  d2 | ... |  T2 |  n  |  D1 |  D2 | ... | ... |
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+

  **NetBIOS over TCP/IP Name Server Option**

   The NetBIOS name server (NBNS) option specifies a list of RFC
   1001/1002 [19] [20] NBNS name servers listed in order of preference.

   The code for this option is 44.  The minimum length of the option is
   4 octets, and the length must always be a multiple of 4.

        Code   Len           Address 1              Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----
      |  44 |  n  |  a1 |  a2 |  a3 |  a4 |  b1 |  b2 |  b3 |  b4 | ...
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----

  **NetBIOS over TCP/IP Datagram Distribution Server Option**

   The NetBIOS datagram distribution server (NBDD) option specifies a
   list of RFC 1001/1002 NBDD servers listed in order of preference. The
   code for this option is 45.  The minimum length of the option is 4
   octets, and the length must always be a multiple of 4.

        Code   Len           Address 1              Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----
      |  45 |  n  |  a1 |  a2 |  a3 |  a4 |  b1 |  b2 |  b3 |  b4 | ...
      +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----

  **NetBIOS over TCP/IP Node Type Option**

   The NetBIOS node type option allows NetBIOS over TCP/IP clients which
   are configurable to be configured as described in RFC 1001/1002.  The
   value is specified as a single octet which identifies the client type
   as follows:

      Value         Node Type
      -----         ---------
      0x1           B-node
      0x2           P-node
      0x4           M-node
      0x8           H-node

   In the above chart, the notation '0x' indicates a number in base-16
   (hexadecimal).

   The code for this option is 46.  The length of this option is always
   1.

        Code   Len  Node Type
      +-----+-----+-----------+
      |  46 |  1  | see above |
      +-----+-----+-----------+

  **NetBIOS over TCP/IP Scope Option**

   The NetBIOS scope option specifies the NetBIOS over TCP/IP scope
   parameter for the client as specified in RFC 1001/1002. See [19],
   [20], and [8] for character-set restrictions.

   The code for this option is 47.  The minimum length of this option is
   1.

        Code   Len       NetBIOS Scope
      +-----+-----+-----+-----+-----+-----+----
      |  47 |  n  |  s1 |  s2 |  s3 |  s4 | ...
      +-----+-----+-----+-----+-----+-----+----

  **X Window System Font Server Option**

   This option specifies a list of X Window System [21] Font servers
   available to the client. Servers SHOULD be listed in order of
   preference.

   The code for this option is 48.  The minimum length of this option is
   4 octets, and the length MUST be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+---
      |  48 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |   ...
      +-----+-----+-----+-----+-----+-----+-----+-----+---

  **X Window System Display Manager Option**

   This option specifies a list of IP addresses of systems that are
   running the X Window System Display Manager and are available to the
   client.

   Addresses SHOULD be listed in order of preference.

   The code for the this option is 49. The minimum length of this option
   is 4, and the length MUST be a multiple of 4.

        Code   Len         Address 1               Address 2

      +-----+-----+-----+-----+-----+-----+-----+-----+---
      |  49 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |   ...
      +-----+-----+-----+-----+-----+-----+-----+-----+---

  **Network Information Service+ Domain Option**

   This option specifies the name of the client's NIS+ [17] domain.  The
   domain is formatted as a character string consisting of characters
   from the NVT ASCII character set.

   The code for this option is 64.  Its minimum length is 1.

        Code   Len      NIS Client Domain Name
      +-----+-----+-----+-----+-----+-----+---
      |  64 |  n  |  n1 |  n2 |  n3 |  n4 | ...
      +-----+-----+-----+-----+-----+-----+---

  **Network Information Service+ Servers Option**

   This option specifies a list of IP addresses indicating NIS+ servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for this option is 65.  Its minimum length is 4, and the
   length MUST be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      |  65 |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Mobile IP Home Agent option**

   This option specifies a list of IP addresses indicating mobile IP
   home agents available to the client.  Agents SHOULD be listed in
   order of preference.

   The code for this option is 68.  Its minimum length is 0 (indicating
   no home agents are available) and the length MUST be a multiple of 4.
   It is expected that the usual length will be four octets, containing
   a single home agent's address.

        Code Len    Home Agent Addresses (zero or more)
      +-----+-----+-----+-----+-----+-----+--
      | 68  |  n  | a1  | a2  | a3  | a4  | ...
      +-----+-----+-----+-----+-----+-----+--

  **Simple Mail Transport Protocol (SMTP) Server Option**

   The SMTP server option specifies a list of SMTP servers available to
   the client.  Servers SHOULD be listed in order of preference.

   The code for the SMTP server option is 69.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 69  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Post Office Protocol (POP3) Server Option**

   The POP3 server option specifies a list of POP3 available to the
   client.  Servers SHOULD be listed in order of preference.

   The code for the POP3 server option is 70.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 70  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Network News Transport Protocol (NNTP) Server Option**

   The NNTP server option specifies a list of NNTP available to the
   client.  Servers SHOULD be listed in order of preference.

   The code for the NNTP server option is 71. The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 71  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Default World Wide Web (WWW) Server Option**

   The WWW server option specifies a list of WWW available to the
   client.  Servers SHOULD be listed in order of preference.

   The code for the WWW server option is 72.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 72  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Default Finger Server Option**

   The Finger server option specifies a list of Finger available to the
   client.  Servers SHOULD be listed in order of preference.

   The code for the Finger server option is 73.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 73  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Default Internet Relay Chat (IRC) Server Option**

   The IRC server option specifies a list of IRC available to the
   client.  Servers SHOULD be listed in order of preference.

   The code for the IRC server option is 74.  The minimum length for
   this option is 4 octets, and the length MUST always be a multiple of
   4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 74  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **StreetTalk Server Option**

   The StreetTalk server option specifies a list of StreetTalk servers
   available to the client.  Servers SHOULD be listed in order of
   preference.

   The code for the StreetTalk server option is 75.  The minimum length
   for this option is 4 octets, and the length MUST always be a multiple
   of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 75  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **StreetTalk Directory Assistance (STDA) Server Option**

   The StreetTalk Directory Assistance (STDA) server option specifies a
   list of STDA servers available to the client.  Servers SHOULD be
   listed in order of preference.

   The code for the StreetTalk Directory Assistance server option is 76.
   The minimum length for this option is 4 octets, and the length MUST
   always be a multiple of 4.

        Code   Len         Address 1               Address 2
      +-----+-----+-----+-----+-----+-----+-----+-----+--
      | 76  |  n  |  a1 |  a2 |  a3 |  a4 |  a1 |  a2 |  ...
      +-----+-----+-----+-----+-----+-----+-----+-----+--

  **Requested IP Address**

   This option is used in a client request (DHCPDISCOVER) to allow the
   client to request that a particular IP address be assigned.

   The code for this option is 50, and its length is 4.

        Code   Len          Address
      +-----+-----+-----+-----+-----+-----+
      |  50 |  4  |  a1 |  a2 |  a3 |  a4 |
      +-----+-----+-----+-----+-----+-----+

  **IP Address Lease Time**

   This option is used in a client request (DHCPDISCOVER or DHCPREQUEST)
   to allow the client to request a lease time for the IP address.  In a
   server reply (DHCPOFFER), a DHCP server uses this option to specify
   the lease time it is willing to offer.

   The time is in units of seconds, and is specified as a 32-bit
   unsigned integer.

   The code for this option is 51, and its length is 4.

        Code   Len         Lease Time
      +-----+-----+-----+-----+-----+-----+
      |  51 |  4  |  t1 |  t2 |  t3 |  t4 |
      +-----+-----+-----+-----+-----+-----+

  **Option Overload**

   This option is used to indicate that the DHCP 'sname' or 'file'
   fields are being overloaded by using them to carry DHCP options. A
   DHCP server inserts this option if the returned parameters will
   exceed the usual space allotted for options.

   If this option is present, the client interprets the specified
   additional fields after it concludes interpretation of the standard
   option fields.

   The code for this option is 52, and its length is 1.  Legal values
   for this option are:

           Value   Meaning
           -----   --------
             1     the 'file' field is used to hold options
             2     the 'sname' field is used to hold options
             3     both fields are used to hold options

        Code   Len  Value
      +-----+-----+-----+
      |  52 |  1  |1/2/3|
      +-----+-----+-----+

  **TFTP server name**

   This option is used to identify a TFTP server when the 'sname' field
   in the DHCP header has been used for DHCP options.

   The code for this option is 66, and its minimum length is 1.

       Code  Len   TFTP server
      +-----+-----+-----+-----+-----+---
      | 66  |  n  |  c1 |  c2 |  c3 | ...
      +-----+-----+-----+-----+-----+---

  **Bootfile name**

   This option is used to identify a bootfile when the 'file' field in
   the DHCP header has been used for DHCP options.

   The code for this option is 67, and its minimum length is 1.

       Code  Len   Bootfile name
      +-----+-----+-----+-----+-----+---
      | 67  |  n  |  c1 |  c2 |  c3 | ...
      +-----+-----+-----+-----+-----+---

  **DHCP Message Type**

   This option is used to convey the type of the DHCP message.  The code
   for this option is 53, and its length is 1.  Legal values for this
   option are:

           Value   Message Type
           -----   ------------
             1     DHCPDISCOVER
             2     DHCPOFFER
             3     DHCPREQUEST
             4     DHCPDECLINE
             5     DHCPACK
             6     DHCPNAK
             7     DHCPRELEASE
             8     DHCPINFORM

        Code   Len  Type
      +-----+-----+-----+
      |  53 |  1  | 1-9 |
      +-----+-----+-----+

  **Server Identifier**

   This option is used in DHCPOFFER and DHCPREQUEST messages, and may
   optionally be included in the DHCPACK and DHCPNAK messages.  DHCP
   servers include this option in the DHCPOFFER in order to allow the
   client to distinguish between lease offers.  DHCP clients use the
   contents of the 'server identifier' field as the destination address
   for any DHCP messages unicast to the DHCP server.  DHCP clients also
   indicate which of several lease offers is being accepted by including
   this option in a DHCPREQUEST message.

   The identifier is the IP address of the selected server.

   The code for this option is 54, and its length is 4.

        Code   Len            Address
      +-----+-----+-----+-----+-----+-----+
      |  54 |  4  |  a1 |  a2 |  a3 |  a4 |
      +-----+-----+-----+-----+-----+-----+

  **Parameter Request List**

   This option is used by a DHCP client to request values for specified
   configuration parameters.  The list of requested parameters is
   specified as n octets, where each octet is a valid DHCP option code
   as defined in this document.

   The client MAY list the options in order of preference.  The DHCP
   server is not required to return the options in the requested order,
   but MUST try to insert the requested options in the order requested
   by the client.

   The code for this option is 55.  Its minimum length is 1.

        Code   Len   Option Codes
      +-----+-----+-----+-----+---
      |  55 |  n  |  c1 |  c2 | ...
      +-----+-----+-----+-----+---

  **Message**

   This option is used by a DHCP server to provide an error message to a
   DHCP client in a DHCPNAK message in the event of a failure. A client
   may use this option in a DHCPDECLINE message to indicate the why the
   client declined the offered parameters.  The message consists of n
   octets of NVT ASCII text, which the client may display on an
   available output device.

   The code for this option is 56 and its minimum length is 1.

        Code   Len     Text
      +-----+-----+-----+-----+---
      |  56 |  n  |  c1 |  c2 | ...
      +-----+-----+-----+-----+---

  **Maximum DHCP Message Size**

   This option specifies the maximum length DHCP message that it is
   willing to accept.  The length is specified as an unsigned 16-bit
   integer.  A client may use the maximum DHCP message size option in
   DHCPDISCOVER or DHCPREQUEST messages, but should not use the option
   in DHCPDECLINE messages.

   The code for this option is 57, and its length is 2.  The minimum
   legal value is 576 octets.

        Code   Len     Length
      +-----+-----+-----+-----+
      |  57 |  2  |  l1 |  l2 |
      +-----+-----+-----+-----+

  **Renewal (T1) Time Value**

   This option specifies the time interval from address assignment until
   the client transitions to the RENEWING state.

   The value is in units of seconds, and is specified as a 32-bit
   unsigned integer.

   The code for this option is 58, and its length is 4.

        Code   Len         T1 Interval
      +-----+-----+-----+-----+-----+-----+
      |  58 |  4  |  t1 |  t2 |  t3 |  t4 |
      +-----+-----+-----+-----+-----+-----+

  **Rebinding (T2) Time Value**

   This option specifies the time interval from address assignment until
   the client transitions to the REBINDING state.

   The value is in units of seconds, and is specified as a 32-bit
   unsigned integer.

   The code for this option is 59, and its length is 4.

        Code   Len         T2 Interval
      +-----+-----+-----+-----+-----+-----+
      |  59 |  4  |  t1 |  t2 |  t3 |  t4 |
      +-----+-----+-----+-----+-----+-----+

  **Vendor class identifier**

   This option is used by DHCP clients to optionally identify the vendor
   type and configuration of a DHCP client.  The information is a string
   of n octets, interpreted by servers.  Vendors may choose to define
   specific vendor class identifiers to convey particular configuration
   or other identification information about a client.  For example, the
   identifier may encode the client's hardware configuration.  Servers
   not equipped to interpret the class-specific information sent by a
   client MUST ignore it (although it may be reported). Servers that

   respond SHOULD only use option 43 to return the vendor-specific
   information to the client.

   The code for this option is 60, and its minimum length is 1.

      Code   Len   Vendor class Identifier
      +-----+-----+-----+-----+---
      |  60 |  n  |  i1 |  i2 | ...
      +-----+-----+-----+-----+---

  **Client-identifier**

   This option is used by DHCP clients to specify their unique
   identifier.  DHCP servers use this value to index their database of
   address bindings.  This value is expected to be unique for all
   clients in an administrative domain.

   Identifiers SHOULD be treated as opaque objects by DHCP servers.

   The client identifier MAY consist of type-value pairs similar to the
   'htype'/'chaddr' fields defined in [3]. For instance, it MAY consist
   of a hardware type and hardware address. In this case the type field
   SHOULD be one of the ARP hardware types defined in -old STD2-
   [RFC1700](https://datatracker.ietf.org/doc/html/rfc1700) replaced by
   [New IANA online database](https://www.iana.org/assignments/arp-parameters/arp-parameters.xhtml#hardware-types).
   A hardware type of 0 (zero) should be used when the value field
   contains an identifier other than a hardware address (e.g. a fully
   qualified domain name).

   For correct identification of clients, each client's client-
   identifier MUST be unique among the client-identifiers used on the
   subnet to which the client is attached.  Vendors and system
   administrators are responsible for choosing client-identifiers that
   meet this requirement for uniqueness.

   The code for this option is 61, and its minimum length is 2.

      Code   Len   Type  Client-Identifier
      +-----+-----+-----+-----+-----+---
      |  61 |  n  |  t1 |  i1 |  i2 | ...
      +-----+-----+-----+-----+-----+---
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
      options |> Enum.map(fn opt -> DHCP.to_binary(opt) end) |> Enum.join(<<>>)

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
        {"NetBIOS over TCP/IP Datagram Distribution Server", :ip_list,
         value |> to_ip_address_list(length)}

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
          {8, "DHCPINFORM", "Client requests configuration without an IP"}
        ]

        type_int = value |> to_int(8)

        message =
          Enum.find_value(message_types, type_int, fn {id, type_message, desc} ->
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
        # Type  Client-Identifier
        # {"Client-identifier", :int_list, value |> to_int_list(8, length)}
        {"Client-identifier", :type_identifier, value |> to_type_identifier(length)}

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
        {"Classless Static Route Option", :network_mask_router_list,
         value |> to_mask_network_route_list(length)}

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

    {network, router, rest, size} =
      case mask do
        0 ->
          <<router::binary-size(4), rest::binary>> = rest
          {{0, 0, 0, 0}, router, rest, 5}

        n when n >= 1 and n <= 8 ->
          <<a::8, router::binary-size(4), rest::binary>> = rest
          {{a, 0, 0, 0}, router, rest, 6}

        n when n >= 9 and n <= 16 ->
          <<a::8, b::8, router::binary-size(4), rest::binary>> = rest
          {{a, b, 0, 0}, router, rest, 7}

        n when n >= 17 and n <= 24 ->
          <<a::8, b::8, c::8, router::binary-size(4), rest::binary>> = rest
          {{a, b, c, 0}, router, rest, 8}

        n when n >= 25 and n <= 32 ->
          <<a::8, b::8, c::8, d::8, router::binary-size(4), rest::binary>> = rest
          {{a, b, c, d}, router, rest, 9}
      end

    [{network, mask, router} | to_mask_network_route_list(rest, len - size)]
  end

  defp to_type_identifier(<<type::8, identifier::binary>>, _len) do
    case type do
      0 ->
        {"Non-hardware", identifier}

      1 ->
        mac =
          identifier
          |> :binary.part(0, 6)
          |> Base.encode16(case: :lower)
          |> String.replace(~r/(..)/, "\\1:")
          |> String.trim_trailing(":")

        {"Ethernet", mac}

      _ ->
        {type, identifier}
    end
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
      Option(#{option.type}): #{parse_decoded_value(decoded_value)}
      """
    end

    @spec parse_decoded_value(
            {any(),
             :binary
             | :bool
             | :int
             | :int_list
             | :ip
             | :ip_list
             | :ip_mask_list
             | :network_mask_router_list
             | :raw, any()}
          ) :: <<_::16, _::_*8>>
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
          "#{name}: #{value |> inspect()}"

        :type_identifier ->
          {type, identifier} = value
          "#{name}: #{type} #{identifier |> inspect()}"

        :raw ->
          "#{name}: #{value |> inspect()}"
      end
    end
  end
end
