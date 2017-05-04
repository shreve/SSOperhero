defmodule Ssoperhero.UserController do
  use Ssoperhero.Web, :controller

  alias Ssoperhero.User

  def show(conn, %{"token" => token}) do
    case Ssoperhero.Token.read(token) do
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
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User account created!")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
