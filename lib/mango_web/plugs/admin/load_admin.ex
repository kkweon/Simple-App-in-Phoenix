defmodule MangoWeb.Plugs.Admin.LoadAdmin do
  @moduledoc """
  (1) Reads admin from session[:admin_id]
  (2) Assigns conn[:current_admin] = admin
  """
  import Plug.Conn
  alias Mango.Administration
  def init(_opts) do
    nil
  end

  def call(%Plug.Conn{} = conn, _opts) do
    admin_id = conn |> get_session(:admin_id)
    admin = admin_id && Administration.get_user!(admin_id)
    assign(conn, :current_admin, admin)
  end
end
