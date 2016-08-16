defmodule Ssoperhero.SessionController do
  use Ssoperhero.Web, :controller

  alias Ssoperhero.User
  alias Ssoperhero.Client
  alias Ssoperhero.Token

  def action(conn, _) do
    args = case Client.find_by_conn(conn) do
      {:ok, client} ->
               [
                 conn
                 |> put_resp_header("Access-Control-Allow-Origin", client.domain)
                 |> put_resp_header("Access-Control-Allow-Credentials", "true"),
                 conn.params, client]
      {:error, _} ->
        [conn, conn.params, nil]
    end
    apply(__MODULE__, action_name(conn), args)
  end

  require IEx

  def create(conn, %{"user" => %{"login" => login, "password" => password}}, client) do
    case User.authenticate(login, password) do
      {:ok, user} ->
        conn = conn
        |> put_session(:user_id, user.id)
        |> put_session(:auth_exp, :os.system_time(:seconds) + 3600)
        case client do
          nil ->
            conn
          client ->
            render(conn, token: Token.create(user, client))
        end
      {:error, msg} ->
        conn
        |> put_status(:unauthorized)
        |> render(error: msg)
    end
  end

  def create(conn, %{"user" => %{"password" => password}}, client) do
    IEx.pry
  end

  def show(conn, _assigns, client) do
    case current_user(conn) do
      {:ok, user} ->
        case client do
          nil ->
            conn
          client ->
            case session_expiry(conn) do
              {:ok, expiry} ->
                render(conn, token: Token.create(user, client, expiry))
              {:error, msg} ->
                conn
                |> put_status(:unauthorized)
                |> render(error: msg)
            end
        end
      {:error, msg} ->
        conn
        |> put_status(:unauthorized)
        |> render(error: msg)
    end
  end

  defp current_user(conn) do
    case get_session(conn, :user_id) do
      nil ->
        {:error, "not logged in"}
      id ->
        case Repo.get(User, id) do
          nil ->
            {:error, "user not found"}
          user ->
            {:ok, user}
        end
    end
  end

  defp session_expiry(conn) do
    case get_session(conn, :auth_exp) do
      nil ->
        {:error, "session expired"}
      exp ->
        if :os.system_time(:seconds) > exp do
          {:error, "must log in again"}
        else
          {:ok, exp}
        end
    end
  end
end
