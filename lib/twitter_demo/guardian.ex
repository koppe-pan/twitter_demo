defmodule TwitterDemo.Guardian do
  use Guardian, otp_app: :twitter_demo

  alias TwitterDemo.Repo
  alias TwitterDemo.Users.User

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}

    # tokenをdecodeすると、tokenの文字列の一部としてsub=xxxとidが表示される。
    # resource_from_claimsの中でclaims["sub"]としてidが取り出されている。
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Repo.get(User, id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
