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
    resources "/users", UserController, only: [:create]

    pipe_through :authenticated
    resources "/users", UserController, except: [:new, :create, :edit]
  end

  scope "/", TwitterDemoWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
