defmodule TwitterDemo.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwitterDemo.Repo
  alias TwitterDemo.Tweets.Tweet
  alias TwitterDemo.Users.User
  alias TwitterDemo.Users

  schema "tweets" do
    field :description, :string
    field :favorited, :boolean, default: false
    field :favorites, :integer, default: 0
    belongs_to :user, User
    has_many :comments, TwitterDemo.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:description, :favorited, :favorites])
    |> validate_required([:description, :favorited, :favorites])
  end
end
