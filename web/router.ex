defmodule Ssoperhero.Router do
  use Ssoperhero.Web, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/", Ssoperhero do
    pipe_through :browser

    get "/register", UserController, :new
    post "/register", UserController, :create

    post "/login", SessionController, :create
    get "/session", SessionController, :show

    # scope "/embed", Ssoperhero do
    #   get "/session", SessionController, :show
    # end
  end


  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes
  end
end
