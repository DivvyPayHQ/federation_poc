# Federation PoC

This is to showcase how GraphQL [federation](https://www.apollographql.com/docs/federation/)
would be used in practice with Elixir.

## Setup

Start each of the Elixir subgraph services in separate terminal windows.

```
$ cd <products|reviews|inventory>
$ mix deps.get
$ mix phx.server
```

Start the federated gateway.

```
$ cd gateway
$ yarn
$ yarn start
```

## GraphiQL Playgrounds

- Gateway http://localhost:4000
- Products http://localhost:4001
- Reviews http://localhost:4002
- Inventory http://localhost:4003

## Schemas

### [Inventory Schema](./inventory/lib/inventory_web/schema.ex)

```graphql
schema @link(url: "https:\/\/specs.apollo.dev\/federation\/v2.0", import: ["@key", "@extends", "@external"]) {
  query: RootQueryType
  mutation: RootMutationType
}

type Product @extends @key(fields: "upc") {
  upc: String! @external
  inStock: Boolean
}

type RootQueryType @extends {}

type RootMutationType {
  decrementInventory(upc: String!, amount: Int): String
}
```

### [Products Schema](./products/lib/products_web/schema.ex)

```graphql
schema @link(url: "https://specs.apollo.dev/federation/v2.0", import: ["@key"]) {
  query: RootQueryType
  mutation: RootMutationType
}

type Product @key(fields: "upc") {
  upc: String!
  name: String!
  price: Int
}

type RootQueryType {
  product(upc: String!): Product
}

type RootMutationType {
  addDiscount(upc: String!, amount: Int!): String
}
```

### [Reviews Schema](./reviews/lib/reviews_web/schema.ex)

> Note: The reviews schema does not import the Federation v2 directives but it
> will be converted to v2 schema by the gateway.

```graphql
schema {
  query: RootQueryType
}

type Product @extends @key(fields: "upc") {
  upc: String! @external
  reviews: [Review]
}

type Review @key(fields: "id") {
  id: ID!
}

type RootQueryType @extends {
  review(id: ID!): Review
}
```

## Information

The meat of this PoC is in the `schema.ex` of each service and in the [absinthe_federation](https://github.com/DivvyPayHQ/absinthe_federation) library that pulls in some additional macros
