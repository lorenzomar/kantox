defmodule Cashier.Support.MoneyHelperTest do
  use ExUnit.Case

  alias Cashier.Support.MoneyHelper

  test "sum/1" do
    [
      {Money.new(300), [Money.new(300)]},
      {Money.new(350), [Money.new(300), Money.new(50)]}
    ]
    |> Enum.map(fn {expected_amount, moneys} ->
      assert expected_amount == MoneyHelper.sum(moneys)
    end)
  end
end
