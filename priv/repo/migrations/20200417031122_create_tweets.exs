defmodule TwitterDemo.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add(:description, :string)
      add(:favorites, :integer)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end
  end
end
