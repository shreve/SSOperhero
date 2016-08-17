defmodule Ssoperhero.SessionView do
  use Ssoperhero.Web, :view

  def render("show.json", %{token: token}) do
    %{ "token" => token }
  end

  def render("error.json", %{error: message, user: user}) do
    %{ "error" => message, "user" => render(Ssoperhero.UserView, "user.json", user: user) }
  end

  def render("error.json", %{error: message}) do
    %{ "error" => message }
  end
end
