defmodule Mango.CatalogTest do
  # test and assert
  use ExUnit.Case
  alias Mango.Catalog
  alias Mango.Catalog.Product

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
