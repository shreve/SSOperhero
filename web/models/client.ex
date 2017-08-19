defmodule SSO.Client do
  use SSO.Web, :model
  require IEx

  schema "clients" do
    field :name, :string
    field :domain, :string
    field :secret, :string

    has_many :users, SSO.User

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

  def find(id) do
    Repo.get_by(SSO.Client, [id: id])
  end

  def find_by_domain(url) do
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"
    if uri.port do
      domain = domain <> ":#{uri.port}"
    end
    Repo.get_by(SSO.Client, [domain: domain])
  end

  def find_by_conn(conn) do
    headers = conn.req_headers |> Enum.into(%{})
    # auth_domain = Application.get_env(:sso, SSO.Endpoint)[:url][:host]
    request_domain = headers["x-origin"] || headers["origin"] || headers["referer"]

    case request_domain do
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
end
