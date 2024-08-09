defmodule Cashier do
  @moduledoc false

  alias Cashier.PriceEngine
  alias Cashier.Product
  alias Cashier.Products

  @spec checkout([Product.code()]) :: Money.t()
  def checkout(items) do
    items
    |> scan_items()
    |> items_to_facts()
    |> PriceEngine.compute()
  end

  defp scan_items(items) do
    items
    |> Products.get_all_by_codes()
    |> Enum.map(fn product ->
      product
      |> Map.take([:code, :price])
      |> Map.put(:quantity, Enum.count(items, &(&1 == product.code)))
    end)
  end

  defp items_to_facts(items) do
    Enum.flat_map(items, &item_to_facts/1)
  end

  defp item_to_facts(%{code: code, quantity: quantity, price: price}) do
    subtotal = Money.multiply(price, quantity)

    [
      {code, :quantity, quantity},
      {code, :price, price},
      {code, :subtotal, subtotal},
      {:subtotals, :item, subtotal}
    ]
  end
end
