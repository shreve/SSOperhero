defmodule SSO.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :encrypted_password, :string
      add :last_login_at, :datetime

      timestamps()
    end

    create index(:users, [:email])
  end
end
