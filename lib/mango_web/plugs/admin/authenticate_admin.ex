defmodule MangoWeb.Plugs.Admin.AuthenticateAdmin do
  @moduledoc """
  Ensures the current_admin is not nil
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(_opts) do
    nil
  end

  def call(%Plug.Conn{} = conn, _opts) do
    case conn.assigns[:current_admin] do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_layout(false)
        |> render(MangoWeb.ErrorView, "404.html")
        |> halt()

      _ ->
        conn
    end
  end
end
