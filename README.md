# Federation PoC

This is to showcase how [federation](https://www.apollographql.com/docs/federation/) would be used in practice with elixir
## Setup

Start each of the Elixir federated services in separate terminal windows.

```
$ cd <products|reviews|inventory>
$ mix deps.get
$ mix phx.server
```

Start Gateway

```
$ cd gateway
$ yarn install
$ yarn start
```

## GraphiQL

- Gateway http://localhost:4000
- Products http://localhost:4001
- Reviews http://localhost:4002
- Inventory http://localhost:4003

## Schemas

### [Products Schema](./products/lib/products_web/schema.ex)

```elixir
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
```

#### Schema SDL

```graphql
query @extends {
  product(upc: String!): Product
}

type Product @key(fields: "upc") {
  upc: String!
  name: String!
  price: Int
}
```

### [Reviews Schema](./reviews/lib/reviews_web/schema.ex)

```elixir
defmodule ReviewsWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Federation.Schema

  @reviews [
    %{id: 1},
    %{id: 2}
  ]

  query do
    extends()

    field :review, :review do
      arg(:id, non_null(:id))
    end
  end

  object :review do
    key_fields("id")
    field(:id, non_null(:id))

    field(:_resolve_reference, :review) do
      resolve(fn _, _args, _ ->
        {:ok, %{__typename: "Review"}}
      end)
    end
  end

  object :product do
    key_fields("upc")
    extends()

    field :upc, non_null(:string) do
      external()
    end

    field(:reviews, list_of(:review)) do
      resolve(fn _, _ -> {:ok, @reviews} end)
    end

    field(:_resolve_reference, :product) do
      resolve(fn _args, _ ->
        {:ok, %{__typename: "Product"}}
      end)
    end
  end
end
```

#### Schema SDL

```graphql
query @extends {
  review(id: ID!): Review
}

type Review @key(fields: "id") {
  id: ID! 
}

type Product @extends @key(fields: "upc") {
  upc: String! @external
  reviews: [Review]
}
```

### [Inventory Schema](./inventory/lib/inventory_web/schema.ex)

```elixir
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
      resolve(fn _, _ -> {:ok, true} end)
    end
  end
end
```

#### Schema SDL

```graphql
query @extends {}

type Product @extends @key(fields: "upc") {
  upc: String! @external
  inStock: Boolean!
}
```

## Information

The meat of this PoC is in the `schema.ex` of each service and in the [absinthe_federation](https://github.com/DivvyPayHQ/absinthe_federation) library that pulls in some additional macros
