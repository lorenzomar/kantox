defmodule Cashier.Product do
  @moduledoc false

  @type code :: String.t()
  @type t :: %__MODULE__{
          code: code(),
          name: String.t(),
          price: Money.t()
        }

  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price]
end
