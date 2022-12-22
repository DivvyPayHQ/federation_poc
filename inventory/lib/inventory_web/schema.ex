defmodule InventoryWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Federation.Schema

  link(url: "https://specs.apollo.dev/federation/v2.0", import: ["@key", "@extends", "@external"])

  query do
    extends()
  end

  mutation do
    field :decrement_inventory, :string do
      arg(:upc, non_null(:string))
      arg(:amount, :integer, default_value: 1)

      resolve(&resolve_decrement_inventory/2)
    end
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

  defp resolve_decrement_inventory(%{upc: upc, amount: amount}, _res),
    do: {:ok, "Decremented the inventory for UPC #{upc} by #{amount}"}
end
