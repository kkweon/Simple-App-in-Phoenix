defmodule MangoWeb.Admin.CustomerController do
  use MangoWeb, :controller

  alias Mango.CRM

  def index(conn, _params) do
    customers = CRM.list_customers()
    render(conn, "index.html", customers: customers)
  end

  def show(conn, %{"id" => customer_id}) do
    customer = CRM.get_customer(customer_id)
    render(conn, "show.html", customer: customer)
  end

end
