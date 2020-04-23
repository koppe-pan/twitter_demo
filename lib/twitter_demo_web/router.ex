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

    resources "/tweets", TweetController, except: [:new, :update, :edit] do
      resources "/comments", CommentController, except: [:new, :update, :edit]
    end

    get "/profiles/:authorname", ProfileController, :show

    post "/tweets/:id/favorite", FavoController, :favo
    delete "/tweets/:id/favorite", FavoController, :unfavo
    post "/profiles/:authorname/follow", ProfileController, :follow
    delete "/profiles/:authorname/unfollow", ProfileController, :unfollow

    pipe_through :authenticated

    put "/user/:name", UserController, :put
    get "/user/:name", UserController, :get
    resources "/users", UserController, except: [:new, :create, :edit]
  end

  scope "/", TwitterDemoWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
