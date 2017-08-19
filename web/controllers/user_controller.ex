defmodule SSO.UserController do
  use SSO.Web, :controller

  alias SSO.User
  alias SSO.Token

  def show(conn, %{"token" => token}) do
    case SSO.Token.read(token) do
      {:error, msg} ->
        render(conn, "error.json", error: msg)
      {:ok, token} ->
        render(conn, "user.json", token: token)
    end
  end

  def new(conn,  _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case conn.assigns.client do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> render(SSO.ErrorView, "error.json", error: "This request didn't come from a recognized source")
      client ->
        # user_params = Map.put(user_params, "client_id", client.id)
        changeset = User.changeset(%User{}, user_params)
        case Repo.insert(changeset) do
          {:ok, user} ->
            user = Repo.preload user, :client
            conn
            |> put_session(:user_id, user.id)
            |> put_session(:auth_exp, :os.system_time(:seconds) + 3600)
            |> render("user.json", token: Token.create(user, client))
          {:error, changeset} ->
            render(conn, "error.json", changeset: changeset)
        end
    end

  end
end
