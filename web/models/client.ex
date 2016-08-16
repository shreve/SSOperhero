defmodule Ssoperhero.Client do
  use Ssoperhero.Web, :model

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

  require IEx
  def find_by_conn(conn) do
    headers = conn.req_headers |> Enum.into(%{})
    case find_by_domain(headers["origin"]) do
      nil ->
        {:error, "not a valid client"}
      client ->
        {:ok, client}
    end
  end

  def find_by_domain(url) do
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"
    Repo.get_by(Ssoperhero.Client, [domain: domain])
  end
end
