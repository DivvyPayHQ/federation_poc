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
      resolve(&resolve_review_by_id/2)
    end
  end

  object :product do
    key_fields("upc")
    extends()

    field :upc, non_null(:string) do
      external()
    end

    field(:reviews, list_of(:review)) do
      resolve(&resolve_reviews_for_product/3)
    end

    field(:_resolve_reference, :product) do
      resolve(&resolve_product_by_upc/2)
    end
  end

  defp resolve_product_by_upc(%{upc: upc}, _ctx),
    do:
      {:ok,
       %{
         __typename: "Product",
         upc: upc,
         reviews: @reviews
       }}

  defp resolve_review_by_id(%{id: _id}, _ctx), do: {:ok, %{__typename: "Review"}}

  defp resolve_reviews_for_product(product, _args, _ctx), do: {:ok, product.reviews}
end
