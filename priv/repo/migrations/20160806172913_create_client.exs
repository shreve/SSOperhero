defmodule SSO.Repo.Migrations.CreateClient do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :domain, :string
      add :secret, :string

      timestamps()
    end

  end
end
