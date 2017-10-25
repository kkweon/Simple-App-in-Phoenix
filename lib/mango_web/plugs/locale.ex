defmodule MangoWeb.Plugs.Locale do
  import Plug.Conn

  def init(_opts) do
    nil
  end

  @doc """
  http://localhost:4000?locale=kr
  Then conn.params["locale"] is `kr`

  (1) To add a new language

    `mix gettext.merge priv/gettext --locale LANGUAGE_CODE_TO_ADD`

  (2) In project, add a text to be translated

    `gettext("Seasonal Products")` or `dgettext("domain", "Seasonal Products")`
    or `ngettext("Seasonal Product", "Seasonal Products", Enum.count(@seasonal_products))`
    or `dngettext("domain", "Seasonal Product", "Seasonal Products", Enum.count(@seasonal_products))`

  (3) Extract gettext texts using the command (web -> .pot)

    `mix gettext.extract`

  (4) Update individual translation files using the command (.pot -> .po)

    `mix gettext.merge priv/gettext`

  However, (3) and (4) can be merged by using the command

    `mix gettext.extract --merge`
  """
  def call(conn, _opts) do
    case conn.params["locale"] || get_session(conn, :locale) do
      nil ->
        conn

      locale ->
        Gettext.put_locale(MangoWeb.Gettext, locale)
        conn |> put_session(:locale, locale)
    end
  end
end
