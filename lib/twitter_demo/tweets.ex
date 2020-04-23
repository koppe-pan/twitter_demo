defmodule TwitterDemo.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false
  alias TwitterDemo.Repo

  alias TwitterDemo.Tweets.Tweet
  alias TwitterDemo.Users.User
  alias TwitterDemo.Users

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets do
    Repo.all(Tweet)
  end

  def list_tweets(%{name: author}) do
    user =
      Users.get_by_name!(author)
      |> Repo.preload(:tweets)

    user.tweets
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tweet!(id), do: Repo.get!(Tweet, id)

  def put_favorited!(tweet = %Tweet{}, user_id) do
    with favorited <- TwitterDemo.Favo.favoring?(tweet.id, user_id) do
      tweet
      |> Map.put(:favorited, favorited)
    end
  end

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(current_user, attrs \\ %{}) do
    current_user
    |> Ecto.build_assoc(:tweets, %{description: attrs["description"]})
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{source: %Tweet{}}

  """
  def change_tweet(%Tweet{} = tweet) do
    Tweet.changeset(tweet, %{})
  end

  def inc_favorites(%Tweet{} = tweet) do
    {1, [%Tweet{favorites: favorites}]} =
      from(t in Tweet, where: t.id == ^tweet.id, select: [:favorites])
      |> Repo.update_all(inc: [favorites: 1])

    put_in(tweet.favorites, favorites)
  end

  def dec_favorites(%Tweet{} = tweet) do
    {1, [%Tweet{favorites: favorites}]} =
      from(t in Tweet, where: t.id == ^tweet.id, select: [:favorites])
      |> Repo.update_all(inc: [favorites: -1])

    put_in(tweet.favorites, favorites)
  end
end
