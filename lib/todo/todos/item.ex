defmodule Todo.Todos.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Todo.Todos.Item


  schema "items" do
    field :description, :string
    belongs_to :user, Todo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
