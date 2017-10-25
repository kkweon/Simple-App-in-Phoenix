defmodule MangoWeb.Admin.OrderController do
  @moduledoc """
  Admin can view all orders
  """
  use MangoWeb, :controller
  alias Mango.Sales

  def index(conn, _params) do
    orders = Sales.list_orders()
    conn
    |> render("index.html", orders: orders)
  end

  def show(conn, %{"id" => order_id}) do
    order = Sales.get_order(order_id)
    conn
    |> render("show.html", order: order)
  end
end
