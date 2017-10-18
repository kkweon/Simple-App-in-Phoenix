defmodule TodoWeb.UserController do
  use TodoWeb, :controller

  alias Todo.Accounts
  alias Todo.Accounts.User

  plug :check_is_admin when action in [:index, :edit, :show, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: page_path(conn, :index))
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def login_confirm(%{params: %{"login_session" => user_param}} = conn, _params) do
    username = user_param["username"]
    password = user_param["password"]

    case Accounts.login_user(username, password) do

      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: page_path(conn, :index))

      {:error, message} ->
        assign(conn, :user, nil)
        |> put_flash(:error, "Login failed: #{message}")
        |> render("login.html")
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def check_is_admin(%{assigns: %{"user" => user}}=conn, _params) do
    if user.username == "kkweon" do
      conn
    else
      conn
      |> put_flash(:error, "not authorized")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  def check_is_admin(conn, _params) do
      conn
      |> put_flash(:error, "not authorized")
      |> redirect(to: page_path(conn, :index))
      |> halt()
  end
end
