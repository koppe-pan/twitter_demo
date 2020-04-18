defmodule TwitterDemo.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :tweet, EctoAssoc.Tweets
    belongs_to :user, EctoAssoc.Users

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
