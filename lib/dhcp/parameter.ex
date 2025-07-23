defprotocol DHCP.Parameter do
  @spec to_iodata(term()) :: binary()
  def to_iodata(value)
end
