defmodule Cashier.PriceEngine do
  @moduledoc false

  alias Cashier.Support.MoneyHelper
  alias Wongi.Engine
  alias Wongi.Engine.DSL

  import Engine
  import DSL

  @spec compute([Engine.fact()]) :: Money.t() | nil
  def compute(facts) do
    new()
    |> compile_rules(promotions_rules())
    |> compile_rules(basket_total_rule())
    |> assert_facts(facts)
    |> select_total()
  end

  defp promotions_rules() do
    [
      rule(
        :green_tea_buy_one_get_one_free_promotion,
        forall: [
          has(var(:product), :quantity, var(:quantity)),
          has(var(:product), :price, var(:price)),
          equal(var(:product), "GR1"),
          gte(var(:quantity), 2),
          assign(:promotion, fn tokens ->
            tokens[:price]
            |> Money.multiply(div(tokens[:quantity], 2))
            |> Money.neg()
          end)
        ],
        do: [
          gen(:subtotals, :promotion_green_tea, var(:promotion))
        ]
      ),
      rule(
        :strawberries_promotions,
        forall: [
          has(var(:product), :quantity, var(:quantity)),
          has(var(:product), :price, var(:price)),
          equal(var(:product), "SR1"),
          gte(var(:quantity), 3),
          filter(var(:price), fn price -> price |> Money.subtract(450) |> Money.positive?() end),
          assign(:discount, fn tokens ->
            tokens[:price]
            |> Money.subtract(450)
            |> Money.multiply(tokens[:quantity])
            |> Money.neg()
          end)
        ],
        do: [
          gen(:subtotals, :promotion_strawberries, var(:discount))
        ]
      ),
      rule(
        :coffee_promotions,
        forall: [
          has(var(:product), :quantity, var(:quantity)),
          has(var(:product), :price, var(:price)),
          equal(var(:product), "CF1"),
          gte(var(:quantity), 3),
          assign(:discount, fn tokens ->
            item_subtotal = Money.multiply(tokens[:price], tokens[:quantity])

            item_subtotal
            |> Money.subtract(Money.multiply(item_subtotal, 2 / 3))
            |> Money.neg()
          end)
        ],
        do: [
          gen(:subtotals, :promotion_coffee, var(:discount))
        ]
      )
    ]
  end

  defp basket_total_rule() do
    [
      rule(
        :basket_total,
        forall: [
          has(:subtotals, :_, var(:subtotals)),
          aggregate(&MoneyHelper.sum/1, :total, over: :subtotals)
        ],
        do: [
          gen(:basket, :total, var(:total))
        ]
      )
    ]
  end

  defp compile_rules(engine, rules) do
    rules
    |> List.wrap()
    |> Enum.reduce(engine, &compile(&2, &1))
  end

  defp assert_facts(engine, facts) do
    Enum.reduce(facts, engine, &assert(&2, &1))
  end

  defp select_total(engine) do
    engine
    |> select(:basket, :total, :_)
    |> Enum.to_list()
    |> Enum.map(& &1.object)
    |> List.first()
  end
end
