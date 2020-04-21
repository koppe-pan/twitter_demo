defmodule TwitterDemo.Repo.Migrations.CreateFavos do
  use Ecto.Migration

  def change do
    create table(:favos) do
      add(:tweet_id, references(:tweets, on_delete: :delete_all), null: false)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:favos, [:tweet_id, :user_id]))
  end
end
