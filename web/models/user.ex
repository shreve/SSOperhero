defmodule Ssoperhero.User do
  use Ssoperhero.Web, :model
  alias Comeonin.Bcrypt
  alias Ssoperhero.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :last_login_at, Ecto.DateTime

    belongs_to :client, Ssoperhero.Client

    timestamps()
  end

  @optional_fields [:name, :email, :password, :encrypted_password, :client_id, :last_login_at]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @optional_fields)
    |> encrypt_password
    |> validate_required([:name, :email, :password])
    |> validate_length(:password, min: 12)
    |> unique_constraint(:name, on: Repo, downcase: true)
    |> unique_constraint(:email, on: Repo, downcase: true)
  end

  def encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, raw} ->
        put_change(changeset, :encrypted_password, Bcrypt.hashpwsalt(raw))
      :error ->
        changeset
    end
  end

  def find_by_login(login) do
    login = login |> String.strip |> String.downcase
    from(u in User, where: fragment("lower(?)", u.name) == ^login
                        or fragment("lower(?)", u.email) == ^login)
    |> Repo.one
    |> Repo.preload(:client)
  end

  def authenticate(%User{} = user, password) do
    case Bcrypt.checkpw(password, user.encrypted_password) do
      false ->
        {:error, "not a valid password"}
      true ->
        {:ok, user}
    end
  end

  def authenticate(login, password) do
    case find_by_login(login) do
      nil ->
        {:error, "not a valid user"}
      user ->
        authenticate(user, password)
    end
  end
end
