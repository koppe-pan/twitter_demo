defmodule TwitterDemo.Favo do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias TwitterDemo.Repo
  alias TwitterDemo.Favo

  schema "favos" do
    belongs_to :tweet, TwitterDemo.Tweets.Tweet
    belongs_to :user, TwitterDemo.Users.User

    timestamps()
  end

  @doc false
  def changeset(favo, attrs) do
    favo
    |> cast(attrs, [:tweet_id, :user_id])
    |> validate_required([:tweet_id, :user_id])
  end

  def favo(tweet_id, user_id) do
    %Favo{}
    |> Favo.changeset(%{tweet_id: tweet_id, user_id: user_id})
    |> Repo.insert()
  end

  def favoring?(tweet_id, user_id) do
    favo =
      Repo.all(
        from(fa in Favo,
          where: fa.tweet_id == ^tweet_id and fa.user_id == ^user_id,
          limit: 1
        )
      )

    !Enum.empty?(favo)
  end

  def unfavo(tweet_id, user_id) do
    favo =
      Repo.one(
        from(fa in Favo,
          where: fa.tweet_id == ^tweet_id and fa.user_id == ^user_id
        )
      )

    Repo.delete(favo)
  end
end
