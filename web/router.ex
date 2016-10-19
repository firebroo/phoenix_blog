defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

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

  scope "/", HelloPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/users/home", SessionController, :home
    get "/users/login", SessionController, :new
    post "/users/login", SessionController, :create
    get "/users/register", UserController, :new
    post "/users/register", UserController, :create
    resources "/categorys", CategoryController do
        resources "/articles", ArticleController do
            resources "/comments", CommentController, only: [:create]
        end
    end
  end

# scope "/admin", HelloPhoenix.Admin, as: :admin do
#   pipe_through :browser
#    
#    resources "/reviews", ReviewController
#    resources "/users", UserController
#k  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloPhoenix do
  #   pipe_through :api
  # end
end
