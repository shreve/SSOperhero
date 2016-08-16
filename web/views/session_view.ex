defmodule Ssoperhero.SessionView do
  use Ssoperhero.Web, :view

  def render("create.json", %{token: token}) do
    %{ "token" => token }
  end

  def render("create.json", %{error: message}) do
    %{ "error" => message }
  end

  def render("show.json", %{token: token}) do
    %{ "token" => token }
  end

  def render("show.json", %{error: message}) do
    %{ "error" => message }
  end
end
