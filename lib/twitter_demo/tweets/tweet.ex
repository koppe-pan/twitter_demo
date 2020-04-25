defmodule TwitterDemo.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwitterDemo.Users.User

  schema "tweets" do
    field :description, :string
    field :favorites, :integer, default: 0
    belongs_to :user, User
    has_many :comments, TwitterDemo.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:description])
    |> validate_required([:description])
    |> validate_changeset
  end

  defp validate_changeset(tweet) do
    tweet
    |> validate_length(:description, max: 140)
  end
end
