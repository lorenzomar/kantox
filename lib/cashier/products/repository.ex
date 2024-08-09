defmodule Cashier.Products.Repository do
  @moduledoc false

  alias Cashier.Product

  @callback get(code :: Product.code(), opts :: keyword) :: Product.t() | nil

  @callback get_all_by_codes(codes :: [Product.code()], opts :: keyword) :: [Product.t()]
end
