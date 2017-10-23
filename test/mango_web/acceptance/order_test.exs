defmodule MangoWeb.OrderTest do
  use MangoWeb.ConnCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Repo
    alias Mango.CRM
    alias Mango.Catalog.Product

    {:ok, _user} =
      CRM.create_customer(%{
        name: "John Doe",
        email: "john@example.com",
        password: "secret",
        residence_area: "Area 1"
      })

    {:ok, _user} =
      CRM.create_customer(%{
        name: "Jane Doe",
        email: "jane@example.com",
        password: "secret",
        residence_area: "Area 2"
      })

    %Product{
      is_seasonal: true,
      image: ".",
      name: "Apple",
      price: Decimal.new(50),
      sku: "sku123",
      category: "fruits",
      pack_size: "1 kg"
    }
    |> Repo.insert!()

    :ok
  end

  test "unauthenciated users redirected to the order history" do
    navigate_to("/orders")

    assert current_path() == "/login"

    message = find_element(:css, ".alert") |> visible_text()
    assert message == "You must be signed in"
  end

  test "authenticated users can view the order history" do
    navigate_to("/login")

    find_element(:css, "#session_email")
    |> fill_field("john@example.com")

    find_element(:css, "#session_password")
    |> fill_field("secret")

    find_element(:css, "button[type=submit]")
    |> click()

    assert current_path() == "/"

    cart_form = find_element(:css, ".cart-form")

    # Add item to the cart
    find_within_element(cart_form, :tag, "button")
    |> click()

    navigate_to("/cart")

    find_element(:link_text, "Checkout")
    |> click()

    assert current_path() == "/checkout"
    assert page_source() =~ "Apple"

    find_element(:css, "button[type=submit]")
    |> click()

    navigate_to("/orders")
    assert page_source() =~ "Order View"
    assert page_source() =~ "Confirmed"
  end

  test "unauthenticated users gets 404" do
    navigate_to("/login")

    # Login as jane
    find_element(:css, "#session_email")
    |> fill_field("jane@example.com")

    find_element(:css, "#session_password")
    |> fill_field("secret")

    find_element(:css, "button[type=submit]")
    |> click()

    assert current_path() == "/"

    # Try access to John's cart
    navigate_to("/orders/1")
    assert page_source() =~ "Page not found"
  end
end
