defmodule TodoWeb.ItemController do
  use TodoWeb, :controller

  alias Todo.Todos
  alias Todo.Todos.Item

  plug :login?

  def index(conn, _params) do
    changeset = Todos.change_item(%Item{})
    items = Todos.list_items_by_user(conn.assigns[:user])
    render(conn, "index.html", items: items, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Todos.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Todos.create_item(conn.assigns.user, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: item_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Todos.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Todos.get_item!(id)
    changeset = Todos.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Todos.get_item!(id)

    case Todos.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: item_path(conn, :show, item))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Todos.get_item!(id)
    {:ok, _item} = Todos.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index))
  end

  defp login?(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:info, "You must login first")
      |> redirect(to: user_path(conn, :login))
    end

  end
end
