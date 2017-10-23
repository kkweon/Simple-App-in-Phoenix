defmodule MangoWeb.HomepageTest do
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
    tomato = %Product{
      name: "Tomato",
      price: 50,
      sku: "A123",
      is_seasonal: false,
      category: "vegetables"
    }

    apple = %Product{
      name: "Apple",
      price: 100,
      sku: "B232",
      is_seasonal: true,
      category: "fruits"
    }

    Repo.insert(tomato)
    Repo.insert(apple)
    :ok
  end

  test "presence of featured products" do
    # Given
    # There are two products Apple and Tomato priced at 100 and 50 respectively
    # With Apple being the only seasonal product

    # When
    navigate_to("/")

    # Then
    # I expect the page title to be "Seasonal Products"
    page_title = find_element(:css, ".page-title") |> visible_text()
    assert page_title =~ "Seasonal Products"

    # Then
    # I expect the Apple is displayed
    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name") |> visible_text()
    product_price = find_within_element(product, :css, ".product-price") |> visible_text()

    assert product_name =~ "Apple"
    assert product_price =~ "100"

    # Tomato is not present on the screen
    refute page_source() =~ "Tomato"
  end
end
