defmodule DHCPv6.Message do
  @moduledoc """
  DHCPv6 message format and parsing according to RFC 3315.
  """

  @type t :: %__MODULE__{
          msg_type: integer(),
          transaction_id: binary(),
          options: [DHCPv6.Option.t()]
        }

  defstruct [
    :msg_type,
    :transaction_id,
    options: []
  ]

  @doc """
  Create a new DHCPv6 message.
  """
  @spec new() :: t()
  def new do
    %__MODULE__{
      msg_type: 0,
      transaction_id: <<0, 0, 0>>,
      options: []
    }
  end

  @doc """
  Parse DHCPv6 message from binary.
  """
  @spec from_iodata(binary()) :: {:ok, t()} | {:error, String.t()}
  def from_iodata(data) when is_binary(data) do
    case parse_message(data) do
      {:ok, message} -> {:ok, message}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Convert DHCPv6 message to binary.
  """
  @spec to_iodata(t()) :: binary()
  def to_iodata(message) do
    transaction_id =
      if byte_size(message.transaction_id) == 3, do: message.transaction_id, else: <<0, 0, 0>>

    header = <<message.msg_type, transaction_id::binary>>
    options = Enum.map(message.options, &DHCPv6.Option.to_iodata/1) |> Enum.join()

    <<header::binary, options::binary>>
  end

  defp parse_message(<<msg_type, transaction_id::binary-size(3), rest::binary>>) do
    case parse_options(rest, []) do
      {:ok, options} ->
        {:ok,
         %__MODULE__{
           msg_type: msg_type,
           transaction_id: transaction_id,
           options: options
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_message(_), do: {:error, "Invalid DHCPv6 message format"}

  defp parse_options("<<>>", acc), do: {:ok, Enum.reverse(acc)}

  defp parse_options(data, acc) do
    case DHCPv6.Option.parse_option(data) do
      {:ok, option, rest} -> parse_options(rest, [option | acc])
      {:error, reason} -> {:error, reason}
    end
  end
end
