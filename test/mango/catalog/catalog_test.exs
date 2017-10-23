defmodule Mango.CatalogTest do
  # test and assert
  use Mango.DataCase
  alias Mango.{Catalog, Repo}
  alias Mango.Catalog.Product

  setup do
    tomato = %Product{name: "Tomato", price: 55, sku: "A123", is_seasonal: false, category: "vegetables"}
    apple = %Product{name: "Apple", price: 75, sku: "B232", is_seasonal: true, category: "fruits"}
    Repo.insert tomato
    Repo.insert apple
    :ok
  end

  test "list_products/0 returns all the products" do
    [p1=%Product{}, p2=%Product{}] = Catalog.list_products()

    assert p1.name == "Tomato"
    assert p2.name == "Apple"
  end

  test "list_seasonal_products/0 returns all seasonal products" do
    [p = %Product{}] = Catalog.list_seasonal_products()
    assert p.name == "Apple"
  end

  test "get_category_products/1 returns products of the given category" do
    [product = %Product{}] = Catalog.get_category_products("fruits")
    assert product.name == "Apple"
  end
end
