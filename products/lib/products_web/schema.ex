defmodule ProductsWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Federation.Schema

  link(url: "https://specs.apollo.dev/federation/v2.0", import: ["@key"])

  query do
    field :product, :product do
      arg(:upc, non_null(:string))
      resolve(&resolve_product_by_upc/2)
    end
  end

  mutation do
    field :add_discount, :string do
      arg(:upc, non_null(:string))
      arg(:amount, non_null(:integer))

      resolve(&resolve_add_discount/2)
    end
  end

  object :product do
    key_fields("upc")
    field(:upc, non_null(:string))
    field(:name, non_null(:string))
    field(:price, :integer)
  end

  defp resolve_product_by_upc(%{upc: upc}, _ctx),
    do: {:ok, %{upc: upc, name: "Test Product", price: 1000}}

  defp resolve_add_discount(%{upc: upc, amount: amount}, _res),
    do: {:ok, "Added $#{amount} discount for the item with UPC #{upc}"}
end
