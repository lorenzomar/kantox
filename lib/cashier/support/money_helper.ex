defmodule Cashier.Support.MoneyHelper do
  @moduledoc false

  def sum([%Money{} = money]), do: money

  def sum([%Money{} = money1 | rest]) do
    Money.add(money1, sum(rest))
  end
end
