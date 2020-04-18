defmodule TwitterDemo.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:body, :string)
      add(:tweet_id, references(:tweets, on_delete: :delete_all), null: false)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end
  end
end
