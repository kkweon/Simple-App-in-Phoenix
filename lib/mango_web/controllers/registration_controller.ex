defmodule MangoWeb.RegistrationController do
  use MangoWeb, :controller
  alias Mango.CRM

  def new(conn, _params) do
    changeset = CRM.build_customer()
    residence_area = Auroville.ResidenceService.list_areas()
    render(conn, "new.html", changeset: changeset, residence_area: residence_area)
  end

  @doc """
  %{ "form_name" => form_submission_data }
  """
  def create(conn, %{"registration" => registration_data}) do
    case CRM.create_customer(registration_data) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Registration successful")
        |> redirect(to: page_path(conn, :index))

      {:error, changeset} ->
        residence_area = Auroville.ResidenceService.list_areas()
        conn
        |> render(:new, changeset: changeset, residence_area: residence_area)
    end
  end
end
