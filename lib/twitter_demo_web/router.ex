defmodule TwitterDemoWeb.Router do
  use TwitterDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug TwitterDemo.Guardian.AuthPipeline
  end

  scope "/api", TwitterDemoWeb do
    pipe_through :api
    post "/sign_in", SessionController, :sign_in
    post "/users", UserController, :create

    get "/tweets/feed", TweetController, :feed
    get "/tweets", TweetController, :index
    post "/tweets", TweetController, :create
    get "/tweets/:id", TweetController, :show
    get "/tweets/:tweet_id/comments", CommentController, :index
    post "/tweets/:tweet_id/comments", CommentController, :create
    get "/tweets/:tweet_id/comments/:id", CommentController, :show
    delete "/tweets/:tweet_id/comments/:id", CommentController, :delete

    get "/profiles/:authorname", ProfileController, :show

    post "/tweets/:id/favorite", FavoController, :favo
    delete "/tweets/:id/favorite", FavoController, :unfavo
    post "/profiles/follow/:authorname", ProfileController, :follow
    delete "/profiles/unfollow/:authorname", ProfileController, :unfollow

    pipe_through :authenticated

    put "/users/:id", UserController, :update
    get "/users/:id", UserController, :show
  end

  scope "/", TwitterDemoWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
