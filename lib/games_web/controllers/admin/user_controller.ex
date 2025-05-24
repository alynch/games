defmodule GamesWeb.Admin.UserController do
  use GamesWeb, :controller

  alias Games.Accounts.User
  alias Games.Repo


  def index(conn, _params) do
    users =   Repo.all(User)
    |> IO.inspect
    render(conn, :index, users: users)
  end
end
