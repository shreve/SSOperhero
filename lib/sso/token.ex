defmodule SSO.Token do
  import Joken

  alias SSO.User
  alias SSO.Client

  def create(%User{} = user, %Client{} = client) do
    create(user, client, current_time() + Application.get_env(:sso, :token_lifetime))
  end

  def create(%User{} = user, %Client{} = client, exp) do
    user
    |> render(client)
    |> token
    |> with_signer(hs256(client.secret))
    |> with_claim("exp", exp)
    |> with_iat
    |> sign
    |> get_compact
  end

  def read(token_string) do
    client_id = token_string |> token |> peek |> Map.get("client_id")
    case Client.find(client_id) do
      nil ->
        {:error, "Token does not include sufficient information to verify"}
      client ->
        token = token_string
        |> token
        |> with_validation("iat", &(&1 < current_time()))
        |> with_validation("exp", &(&1 > current_time()))
        |> with_signer(hs256(client.secret))
        |> verify

        case token.error do
          "Invalid payload" ->
            {:error, "Token is expired or otherwise invalid"}
          _ ->
            {:ok, token}
        end
    end
  end

  defp render(%User{} = user, client) do
    %{ "id" => user.id,
       "username" => user.name,
       "email" => user.email,
       "client_id" => client.id }
  end
end
