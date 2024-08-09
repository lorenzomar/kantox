defmodule Cashier.Products.StaticRepository do
  @moduledoc false

  alias Cashier.Product

  @behaviour Cashier.Products.Repository

  @products [
    %Product{code: "GR1", name: "Green tea", price: Money.new(311, :GBP)},
    %Product{code: "SR1", name: "Strawberries", price: Money.new(500, :GBP)},
    %Product{code: "CF1", name: "Coffee", price: Money.new(1123, :GBP)}
  ]

  @impl true
  def get(code, _opts \\ []) do
    Enum.find(@products, nil, &(&1.code == code))
  end

  @impl true
  def get_all_by_codes(codes, _opts \\ []) do
    codes
    |> Enum.uniq()
    |> Enum.map(&get/1)
    |> Enum.filter(& &1)
  end
end
