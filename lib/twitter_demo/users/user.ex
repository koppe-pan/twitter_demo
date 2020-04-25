defmodule TwitterDemo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias TwitterDemo.Repo
  alias TwitterDemo.Users.User
  alias TwitterDemo.Relationship

  schema "users" do
    field :email, :string
    field :introduction, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :tweets, TwitterDemo.Tweets.Tweet
    has_many :comments, TwitterDemo.Comments.Comment

    # User who follow
    has_many :followed_users, Relationship, foreign_key: :follower_id
    has_many :relationships, through: [:followed_users, :followed_user]

    # Followers the user
    has_many :followers, Relationship, foreign_key: :followed_id
    has_many :reverse_relationships, through: [:followers, :follower]
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :introduction])
    |> validate_required([:email, :name, :password])
    |> validate_changeset
  end

  defp validate_changeset(user) do
    user
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/,
      message: "Must include at least one lowercase letter, one uppercase letter, and one digit"
    )
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  def find_and_confirm_password(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end
end
