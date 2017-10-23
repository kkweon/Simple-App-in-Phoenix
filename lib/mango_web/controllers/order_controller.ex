defmodule MangoWeb.OrderController do
  use MangoWeb, :controller

  alias Mango.Sales

  def index(conn, _params) do
    customer_id = conn.assigns.current_customer.id
    orders = Sales.get_orders_by_userid(customer_id)
    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"order_id" => order_id}) do
    order = Sales.get_order(order_id)
    customer_id = conn.assigns.current_customer.id

    cond do
      customer_id == order.customer_id ->
        render(conn, "show.html", order: order)

      true ->
        conn
        |> put_status(:not_found)
        |> render(MangoWeb.ErrorView, "404.html")
    end
  end
end
