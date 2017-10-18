defmodule TodoWeb.Router do
  use TodoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Todo.Accounts.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", UserController, :login
    post "/login", UserController, :login_confirm
    get "/logout", UserController, :logout


    get "/register", UserController, :new
    post "/register", UserController, :create
    resources "/items", ItemController
  end


  # Other scopes may use custom stacks.
  # scope "/api", TodoWeb do
  #   pipe_through :api
  # end
end
