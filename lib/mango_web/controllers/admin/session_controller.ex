defmodule MangoWeb.Admin.SessionController do
  use MangoWeb, :controller
  alias Mango.Administration
  plug(:set_layout)

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"token" => token}) do
    case verify_token(token) do
      {:ok, user_id} ->
        user = Administration.get_user!(user_id)

        conn
        |> assign(:current_admin, user)
        |> put_session(:admin_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Successfully logged in!")
        |> redirect(to: admin_user_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Authentication Error")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end

  def send_link(conn, %{"session" => %{"email" => email}}) do
    user = Administration.get_admin_by_email(email)

    conn =
      case user do
        nil ->
          conn
          |> put_flash(:error, "User not found error")

        user ->
          link = generate_login_link(conn, user)

          conn
          |> put_flash(:info, "Your magic link is #{link}")
      end

    conn
    |> render("new.html")
  end

  @max_age 600 # 10 minutes
  defp verify_token(token) do
    Phoenix.Token.verify(MangoWeb.Endpoint, "user", token, max_age: @max_age)
  end

  defp generate_login_link(conn, user) do
    token = Phoenix.Token.sign(MangoWeb.Endpoint, "user", user.id)
    admin_session_url(conn, :create, %{token: token})
  end

  defp set_layout(conn, _) do
    conn
    |> put_layout("admin_login.html")
  end
end
