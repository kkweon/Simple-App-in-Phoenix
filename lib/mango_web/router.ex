defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :frontend do
    plug(MangoWeb.Plugs.LoadCustomer)
    plug(MangoWeb.Plugs.FetchCart)
  end

  # Unauthenticated scope
  scope "/", MangoWeb do
    pipe_through([:browser, :frontend])

    get("/", PageController, :index)
    get("/categories/:name", CategoryController, :show)

    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
    get("/register", RegistrationController, :new)
    post("/register", RegistrationController, :create)

    get("/cart", CartController, :show)
    post("/cart", CartController, :add)
    put("/cart", CartController, :update)
  end

  # Authenticated scope
  scope "/", MangoWeb do
    pipe_through([:browser, :frontend, MangoWeb.Plugs.AuthenticateCustomer])

    get("/logout", SessionController, :delete)
    get("/checkout", CheckoutController, :edit)
    put("/checkout/confirm", CheckoutController, :update)

    get("/orders", OrderController, :index)
    get("/orders/:order_id", OrderController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", MangoWeb do
  #   pipe_through :api
  # end
end
