defmodule Mango.CRM do
  alias Mango.CRM.Customer
  alias Mango.Repo

  def list_customers() do
    Repo.all(Customer)
  end

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

      true ->
        :error
    end
  end

  @doc """
  Gets a customer by id
  """
  def get_customer(id) do
    Repo.get(Customer, id)
  end

  alias Mango.CRM.Ticket

  @doc """
  Returns the list of tickets owned by customers

  ## Examples

      iex> list_customer_tickets(%Customer{})
      [%Ticket{}, ...]

  """
  def list_customer_tickets(customer) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.all()
  end

  @doc """
  Gets a single ticket owned by a customer

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_customer_ticket!(%Customer{}, 123)
      %Ticket{}

      iex> get_customer_ticket!(%Customer{}, 456)
      ** (Ecto.NoResultsError)

  """
  def get_customer_ticket!(customer, id) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.get!(id)
  end

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs \\ %{}) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end

  def build_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    customer
    |> Ecto.build_assoc(:tickets, %{status: "New"})
    |> Ticket.changeset(attrs)
  end

  def create_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    build_customer_ticket(customer, attrs)
    |> Repo.insert()
  end
end
