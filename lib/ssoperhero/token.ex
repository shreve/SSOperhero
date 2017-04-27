defmodule Ssoperhero.Token do
  import Joken

  alias Ssoperhero.User
  alias Ssoperhero.Client

  def create(%User{} = user, %Client{} = client) do
    create(user, client, current_time() + Application.get_env(:ssoperhero, :token_lifetime))
  end

  def create(%User{} = user, %Client{} = client, exp) do
    user
    |> render
    |> token
    |> with_signer(hs256(client.secret))
    |> with_claim("sub", "User")
    |> with_claim("exp", exp)
    |> with_iat
    |> sign
    |> get_compact
  end

  defp render(%User{} = user) do
    %{ "id" => user.id, "username" => user.name, "email" => user.email }
  end
end
