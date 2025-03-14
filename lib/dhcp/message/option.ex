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

  defimpl DHCP.Parameter, for: Option do
    @impl true
    def to_binary(%Option{} = option) do
      <<option.type::8, option.length::8, option.value::binary-size(option.length)>>
    end
  end

  defimpl String.Chars, for: Option do
    def to_string(%Option{} = option) do
      """
      Option(#{option.type}): #{inspect(option.value)}
      """
    end
  end
end
