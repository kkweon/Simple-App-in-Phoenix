defmodule MangoWeb.BotChannel do
  use MangoWeb, :channel
  alias Mango.Sales

  def join("pos", payload, socket) do
    welcome_msg = "Welcome to Mango Point of Sales"
    {:ok, %{message: welcome_msg}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (bot:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @doc """
  Checks from the command /status order_id
  handle_in(event_name, payload, socket)
  """
  def handle_in("status", payload, socket) do
    reply =
      case Sales.get_order(payload["message"]) do
        nil ->
          %{message: "Order not found"}

        order ->
          %{message: "Status: #{order.status}"}
      end

    {:reply, {:ok, reply}, socket}
  end

  @doc """
  Admin can create an order through the command `/new`
  """
  def handle_in("new", _, socket) do
    order = Sales.create_cart()
    new_socket = socket |> assign(:order, order)
    reply = %{message: "New order in progress: ##{order.id}"}
    {:reply, {:ok, reply}, new_socket}
  end

  @doc """
  Admin can add an item through `/add item_id quantity`
  """
  def handle_in("add", payload, %Phoenix.Socket{assigns: %{order: order}} = socket) do
    with [item_id, quantity] = String.split(payload["message"], " "),
         {:ok, order} = Sales.add_to_cart(order, %{product_id: item_id, quantity: quantity}) do
      new_socket = socket |> assign(:order, order)
      reply = %{message: "Product added to the order"}

      {:reply, {:ok, reply}, new_socket}
    else
      error ->
        IO.inspect error
        {:reply, {:ok, %{message: "Invalid item"}}, socket}
    end
  end

  @doc """
  /add but order not found
  """
  def handle_in("add", payload, socket) do
    reply = %{message: "Please create an order first through /new"}

    {:reply, {:ok, reply}, socket}
  end

  @doc """
  Complete order /complete
  """
  def handle_in("complete", _, socket) do
    reply = case socket.assigns.order do
              nil ->
                %{message: "Please create a new order through /new"}
              order ->
                Sales.pos_sale_complete(order)
                socket = socket |> assign(:order, nil)
                %{message: "Sale complete. Order Price is total: #{order.total}"}
            end

    {:reply, {:ok, reply}, socket}
  end

  @doc """
  Catches unknown commands
  """
  def handle_in(_, payload, socket) do
    reply = %{message: "I don't understand your question"}
    {:reply, {:error, reply}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
