defmodule MangoWeb.Plugs.FetchCartTest do
  use MangoWeb.ConnCase
  alias Mango.Sales.Order

  test "create and set cart on first visit" do
    conn = get build_conn(), "/"
    cart_id = get_session(conn, :cart_id)
    assert %Order{status: "In Cart"} = conn.assigns.cart
    assert cart_id == conn.assigns.cart.id
  end

  test "Fetch cart from session on subsequent visits" do
    # First visit
    conn = get build_conn(), "/"
    cart_id = get_session(conn, :cart_id)
    # Second visit
    conn = get conn, "/"
    assert cart_id == conn.assigns.cart.id
  end
end
