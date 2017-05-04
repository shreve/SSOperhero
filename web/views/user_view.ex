defmodule Ssoperhero.UserView do
  use Ssoperhero.Web, :view

  def render("user.json", %{token: token}) do
    token.claims
  end

  def render("user.json", %{user: user}) do
    %{ "name" => user.name, "email" => user.email }
  end
end
