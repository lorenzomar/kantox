defmodule Cashier.Products.StaticRepositoryTest do
  use ExUnit.Case

  alias Cashier.Product
  alias Cashier.Products.StaticRepository

  describe "get/2 -" do
    test "product doesn't exists" do
      refute StaticRepository.get("FOO")
    end

    test "found product" do
      assert %Product{} = StaticRepository.get("GR1")
    end
  end

  describe "get_all_by_codes/2 -" do
    test "doesn't return duplicates results" do
      codes = ["GR1", "CF1", "GR1"]
      results = StaticRepository.get_all_by_codes(codes)

      assert 2 == length(results)
      assert Enum.map(results, & &1.code) == Enum.uniq(codes)
    end

    test "doesn't return anything for unknown codes" do
      results = StaticRepository.get_all_by_codes(["FOO", "BAR"])

      assert Enum.empty?(results)
    end
  end
end
