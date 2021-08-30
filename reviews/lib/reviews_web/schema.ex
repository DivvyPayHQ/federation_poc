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
