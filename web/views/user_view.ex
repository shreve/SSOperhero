defmodule SSO.UserView do
  use SSO.Web, :view

  def render("user.json", %{token: token}) do
    %{ "token" => token }
  end

  def render("user.json", %{user: user}) do
    %{ "name" => user.name, "email" => user.email }
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{
        field: field,
        source: %{ pointer: "/data/attributes/#{field}" },
        title: "Invalid Attribute",
        detail: render_detail(detail)
      }
    end)

    %{error: errors}
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  defp render_detail(message) do
    message
  end
end
