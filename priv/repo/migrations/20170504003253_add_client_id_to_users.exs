defmodule Ssoperhero.Repo.Migrations.AddClientIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :client_id, references(:clients)
    end
  end
end
