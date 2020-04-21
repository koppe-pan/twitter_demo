defmodule TwitterDemo.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwitterDemo.Repo
  alias TwitterDemo.Tweets.Tweet
  alias TwitterDemo.Users.User
  alias TwitterDemo.Users

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
    |> cast(attrs, [:description, :favorites])
    |> validate_required([:description, :favorites])
  end
end
