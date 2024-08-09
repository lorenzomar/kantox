defmodule CashierTest do
  use ExUnit.Case

  test "checkout" do
    assert_total(Money.new(2245, :GBP), ["GR1", "SR1", "GR1", "GR1", "CF1"])
    assert_total(Money.new(311, :GBP), ["GR1", "GR1"])
    assert_total(Money.new(1661, :GBP), ["SR1", "SR1", "GR1", "SR1"])
    assert_total(Money.new(3057, :GBP), ["GR1", "CF1", "SR1", "CF1", "CF1"])

    refute Cashier.checkout([])
  end

  defp assert_total(expected_amount, items) do
    assert Money.equals?(expected_amount, Cashier.checkout(items))
  end
end
