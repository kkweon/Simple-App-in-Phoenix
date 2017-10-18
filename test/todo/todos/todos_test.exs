defmodule Todo.TodosTest do
  use Todo.DataCase

  alias Todo.Todos

  describe "items" do
    alias Todo.Todos.Item

    @valid_attrs %{description: "some description"}
    @update_attrs %{description: "some updated description"}
    @invalid_attrs %{description: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Todos.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Todos.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Todos.create_item(@valid_attrs)
      assert item.description == "some description"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Todos.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.description == "some updated description"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_item(item, @invalid_attrs)
      assert item == Todos.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Todos.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Todos.change_item(item)
    end
  end
end
