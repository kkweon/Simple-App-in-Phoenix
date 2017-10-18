defmodule Todo.UserTest do
  use Todo.DataCase

  alias Todo.Accounts

  describe "users" do
    alias Todo.Accounts.User

    @valid_attrs %{password: "some encrypted_password", username: "some username", password_confirmation: "some encrypted_password"}
    @update_attrs %{password: "some updated password", password_confirmation: "some updated password"}
    @invalid_attrs %{password: nil, username: nil, password_confirmation: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end
  end
end
