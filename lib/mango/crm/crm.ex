defmodule Mango.CRM do
  alias Mango.CRM.Customer
  alias Mango.Repo

  def build_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
  end

  @doc """
  Create a customer
  """
  @spec create_customer(map()) :: {:ok, %Customer{}} | {:error, %Ecto.Changeset{}}
  def create_customer(attrs) do
    attrs
    |> build_customer()
    |> Repo.insert()
  end

  @doc """
  Get a Customer by email
  """
  def get_customer_by_email(email), do: Repo.get_by(Customer, email: email)

  @doc """
  Get Customer by credentials(email and password)
  """
  def get_customer_by_credential(%{"email" => email, "password" => password}) do
    customer = get_customer_by_email(email)

    cond do
      customer && Comeonin.Bcrypt.checkpw(password, customer.password_hash) ->
        customer
      true -> :error
    end
  end

  @doc """
  Get Customer by id
  """
  def get_customer(id) do
    Repo.get(Customer, id)
  end
end
