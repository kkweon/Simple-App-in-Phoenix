defmodule Mango.Catalog.Product do
  use Ecto.Schema

  @moduledoc """
  1. Automatically create an elixir struct %Mango.Catalog.Product{}
  2. Mapping data from database products into %Mango.Catalog.Product{}
  """

  schema "products" do
    field :image, :string
    field :is_seasonal, :boolean, default: false
    field :name, :string
    field :price, :decimal
    field :sku, :string
    field :category, :string
    field :pack_size, :string

    timestamps()
  end
end
