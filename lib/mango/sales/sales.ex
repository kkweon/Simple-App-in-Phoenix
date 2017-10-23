defmodule Mango.Sales do
  alias Mango.Repo
  alias Mango.Sales.Order

  def get_cart(id) do
    Order
    |> Repo.get_by(id: id, status: "In Cart")
  end

  def create_cart do
    %Order{status: "In Cart"} |> Repo.insert!()
  end

  def add_to_cart(%Order{line_items: []} = cart, cart_params) do
    attrs = %{line_items: [cart_params]}
    update_cart(cart, attrs)
  end

  def add_to_cart(%Order{line_items: existing_items} = cart, cart_params) do
    new_item = %{
      product_id: String.to_integer(cart_params["product_id"]),
      quantity: String.to_integer(cart_params["quantity"])
    }
    existing_items = existing_items |> Enum.map(&Map.from_struct/1)

    if existing_items |> Enum.filter(fn(item) -> item.product_id == new_item.product_id end) |> length() >=1 do
      new_items = existing_items |> Enum.map(fn(x) ->
        if x.product_id == new_item.product_id do
          %{x | quantity: x.quantity + new_item.quantity}
        else
          x
        end
      end)
      attrs = %{line_items: new_items}
      update_cart(cart, attrs)
    else
      attrs = %{line_items: [new_item | existing_items]}
      update_cart(cart, attrs)
    end
  end

  def update_cart(cart, attrs) do
    cart
    |> Order.changeset(attrs)
    |> Repo.update
  end

  def change_cart(%Order{} = order) do
    Order.changeset(order, %{})
  end

end
