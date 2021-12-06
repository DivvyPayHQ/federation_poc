defmodule InventoryWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Federation.Schema

  query do
    extends()
  end

  object :product do
    key_fields("upc")
    extends()

    field :upc, non_null(:string) do
      external()
    end

    field(:in_stock, :boolean) do
      resolve(&resolve_in_stock_for_product/3)
    end
  end

  defp resolve_in_stock_for_product(%{upc: _upc} = _product, _args, _ctx), do: {:ok, true}
end
