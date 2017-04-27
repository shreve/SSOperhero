defmodule Ssoperhero.Repo.Migrations.UseUuidPrimaryKeyForUsers do
  use Ecto.Migration

  def change do
    execute "create extension pgcrypto"

    alter table(:users) do
      remove :id
      # modify :id, :uuid, primary_key: true
      add :id, :uuid, primary_key: true,
                      default: fragment("gen_random_uuid()")
    end
  end
end
