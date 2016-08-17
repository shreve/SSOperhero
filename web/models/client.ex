defmodule Ssoperhero.Client do
  use Ssoperhero.Web, :model
  require IEx

  schema "clients" do
    field :name, :string
    field :domain, :string
    field :secret, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :domain, :secret])
    |> validate_required([:name, :domain, :secret])
  end

  def find_by_conn(conn) do
    headers = conn.req_headers |> Enum.into(%{})
    sso_domain = Application.get_env(:ssoperhero, Ssoperhero.Endpoint)[:url][:host]
    req_domain = if String.contains?(headers["referer"], "//" <> sso_domain) do
      headers["x-origin"]
    else
      headers["origin"] || headers["referer"]
    end
    case req_domain do
      nil ->
        {:error, "no referrer to find client with"}
      origin ->
        case find_by_domain(origin) do
          nil ->
            {:error, "not a valid client"}
          client ->
            {:ok, client}
        end
    end
  end

  def find_by_domain(url) do
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"
    Repo.get_by(Ssoperhero.Client, [domain: domain])
  end
end
