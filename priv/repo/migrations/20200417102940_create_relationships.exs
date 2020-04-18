defmodule TwitterDemo.Repo.Migrations.CreateRelationships do
  use Ecto.Migration
  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create table(:relationships) do
      add(:follower_id, :integer)
      add(:followed_id, :integer)

      timestamps()
    end

    create(index(:relationships, [:follower_id], concurrently: true))
    create(index(:relationships, [:followed_id], concurrently: true))
    create(unique_index(:relationships, [:follower_id, :followed_id], concurrently: true))
  end
end
