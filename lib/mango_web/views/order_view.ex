defmodule MangoWeb.OrderView do
  use MangoWeb, :view

  def view_order_items(order_list) do
    Enum.map(order_list, fn item ->
      "#{item.product_name} (#{item.quantity})"
    end)
    |> Enum.join(", ")
  end
end
