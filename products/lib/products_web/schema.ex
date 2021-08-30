defmodule ProductsWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Federation.Schema

  query do
    extends()

    field :product, :product do
      arg(:upc, non_null(:string))
      resolve(fn _, _, _ -> {:ok, %{upc: "123", name: "Test Product", price: 1000}} end)
    end
  end

  object :product do
    key_fields("upc")
    field(:upc, non_null(:string))
    field(:name, non_null(:string))
    field(:price, :integer)
  end
end
