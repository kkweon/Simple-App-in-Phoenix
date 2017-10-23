defmodule MangoWeb.Plugs.LoadCustomerTest do
  # Our test uses conn now
  use MangoWeb.ConnCase
  alias Mango.CRM

  @valid_attrs %{
    "name" => "John",
    "email" => "john@example.com",
    "password" => "secret",
    "residence_area" => "Area 1",
    "phone" => "11111"
  }

  test "fetch customer from session on subsequent visit" do
    {:ok, customer} = CRM.create_customer(@valid_attrs)

    # Builds conn by posting login data
    conn = post build_conn(), "/login", %{"session" => @valid_attrs}

    # Reuse the same conn
    conn = get conn, "/"

    assert customer.id == conn.assigns.current_customer.id
  end
end
