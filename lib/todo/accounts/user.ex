defmodule Todo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Todo.Accounts.User
  alias Comeonin.Argon2



  schema "users" do
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :items, Todo.Todos.Item

    timestamps()
  end


  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_required([:username, :password, :password_confirmation])
    |> validate_password(:password)
    |> validate_confirmation(:password)
    |> unique_constraint(:username)
    |> put_pass_hash()
  end


  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  defp valid_password?(_), do: {:error, "The password is too short"}

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end
  defp put_pass_hash(changeset), do: changeset

end
