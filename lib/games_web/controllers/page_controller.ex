defmodule GamesWeb.PageController do
  use GamesWeb, :controller

  alias Games.Admin

  def home(conn, _params) do
    games = Admin.list_games()

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, games: games)
  end
end
