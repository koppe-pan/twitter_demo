defmodule TwitterDemo.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :tweet, TwitterDemo.Tweets.Tweet
    belongs_to :user, TwitterDemo.Users.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_changeset
  end

  defp validate_changeset(comment) do
    comment
    |> validate_length(:body, max: 116)
  end
end
