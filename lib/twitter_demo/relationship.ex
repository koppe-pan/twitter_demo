defmodule TwitterDemo.Relationship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias TwitterDemo.Repo
  alias TwitterDemo.Relationship
  alias TwitterDemo.Users.User

  schema "relationships" do
    belongs_to :followed_user, User, foreign_key: :followed_id
    belongs_to :follower, User, foreign_key: :follower_id

    timestamps()
  end

  @doc false
  def changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:follower_id, :followed_id])
    |> validate_required([:follower_id, :followed_id])
  end

  def follow(signed_id, follow_user_id) do
    %Relationship{}
    |> Relationship.changeset(%{followed_id: signed_id, follower_id: follow_user_id})
    |> Repo.insert()
  end

  def following?(signed_id, follow_user_id) do
    relationship =
      Repo.all(
        from(re in Relationship,
          where: re.followed_id == ^signed_id and re.follower_id == ^follow_user_id,
          limit: 1
        )
      )

    !Enum.empty?(relationship)
  end

  def unfollow(signed_id, follow_user_id) do
    relationship =
      Repo.one(
        from(re in Relationship,
          where: re.followed_id == ^signed_id and re.follower_id == ^follow_user_id
        )
      )

    Repo.delete(relationship)
  end
end
