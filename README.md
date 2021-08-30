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

## Information

The meat of this PoC is in the `schema.ex` of each service and in the [absinthe_federation](https://github.com/DivvyPayHQ/absinthe_federation) library that pulls in some additional macros