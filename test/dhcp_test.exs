defmodule DHCPTest do
  use ExUnit.Case
  doctest DHCP

  test "greets the world" do
    assert DHCP.hello() == :world
  end
end
