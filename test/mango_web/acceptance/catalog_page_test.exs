defmodule MangoWeb.Acceptance.CatalogPageTest do
  use Mango.DataCase
  use Hound.Helpers
  alias Mango.Repo
  alias Mango.Catalog.Product

  hound_session()

  setup do
    ## GIVEN
    # There are two products
    # - Apple $100, categorized as fruits
    # - Tomato $50, categorized as vegetables
    tomato = %Product{name: "Tomato", price: 50, sku: "A123", is_seasonal: false, category: "vegetables"}
    apple = %Product{name: "Apple", price: 100, sku: "B232", is_seasonal: true, category: "fruits"}
    Repo.insert tomato
    Repo.insert apple
    :ok
  end

  test "show fruits" do
    # WHEN
    navigate_to("/categories/fruits")

    # THEN
    # Find Apple $100
    # No Tomato is found
    page_title = find_element(:css, ".page-title") |> visible_text()
    assert page_title == "Fruits"

    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name") |> visible_text()
    product_price = find_within_element(product, :css, ".product-price") |> visible_text()

    assert product_name == "Apple"
    assert product_price == "100"

    refute page_source() =~ "Tomato"

  end

  test "show vegetables" do
    # WHEN
    navigate_to("/categories/vegetables")

    # THEN
    # Title is Vegetables
    page_title = find_element(:css, ".page-title") |> visible_text()
    assert page_title == "Vegetables"

    # Tomato is visible
    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name") |> visible_text()
    product_price = find_within_element(product, :css, ".product-price") |> visible_text()

    assert product_name == "Tomato"
    assert product_price == "50"

    refute page_source() =~ "Apple"

  end
end
