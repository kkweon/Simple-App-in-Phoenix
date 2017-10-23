defmodule MangoWeb.Plugs.LoadCustomer do
  @moduledoc """
  Check session find customer_id
  If found, conn.assigns.current_customer
  """

  import Plug.Conn
  alias Mango.CRM

  def init(_opts) do
    nil
  end

  def call(%Plug.Conn{} = conn, _opts) do
    customer_id = conn |> get_session(:customer_id)
    customer = customer_id && CRM.get_customer(customer_id)
    assign(conn, :current_customer, customer)
  end
end
