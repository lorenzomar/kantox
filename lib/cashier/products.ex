defmodule Cashier.Products do
  @moduledoc false

  @behaviour Cashier.Products.Repository

  @impl true
  def get(code, opts \\ []) do
    repository_adapter().get(code, opts)
  end

  @impl true
  def get_all_by_codes(codes, opts \\ []) do
    repository_adapter().get_all_by_codes(codes, opts)
  end

  defp repository_adapter, do: Application.get_env(:cashier, :products_repository)
end
