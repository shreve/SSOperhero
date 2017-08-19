defmodule SSO.Router do
  use SSO.Web, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    # plug :put_secure_browser_headers

    plug SSO.Plugs.Client
  end

  scope "/", SSO do
    pipe_through :browser

    get "/register", UserController, :new
    post "/register", UserController, :create

    get "/whoami", UserController, :show

    get "/", SessionController, :new
    post "/login", SessionController, :create
    get "/session", SessionController, :show
    get "/logout", SessionController, :destroy
  end


  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes
  end
end
