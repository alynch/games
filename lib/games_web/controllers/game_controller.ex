defmodule GamesWeb.GameController do
  use GamesWeb, :controller

  import Ecto.Query
  alias Games.Repo

  alias Games.Admin
  alias Games.Admin.Game
  alias Games.Admin.Puzzle

  alias Games.Accounts.User

  def archive(conn, %{"id" => id}) do
    game =
      Admin.get_game_by!(id)
      |> IO.inspect()

    render(conn, :archive, game: game)
  end

  def leaderboard(conn, %{"id" => id}) do
    game = Admin.get_game_by!(id)

    users =
      Repo.all(User)
      |> IO.inspect()

    render(conn, :leaderboard, users: users, game: game)
  end

  def show(conn, %{"id" => id, "date" => date}) do
    today = Calendar.strftime(Date.from_iso8601!(date), "%Y-%m-%d")

    case get_game_and_puzzle(id, today) do
      {game, nil} ->
        render(conn, :nopuzzle, game: game, today: today)

      {game, puzzle} ->
        render(conn, :show, game: game, puzzle: puzzle, today: today)

      nil ->
        render(conn, :nogame)
    end
  end

  def show(conn, params) do
    # today = Calendar.strftime(Date.utc_today, "%Y-%m-%d")
    today = Date.utc_today() |> Date.to_iso8601()
    show(conn, Map.put(params, "date", today))
  end

  def get_game_and_puzzle(slug, date) do
    from(g in Game,
      where: g.slug == ^slug,
      left_join: p in assoc(g, :puzzles),
      #      on: p.date == ^date,
      order_by: [asc: p.inserted_at],
      limit: 1,
      select: {g, p}
    )
    |> Games.Repo.one()
  end
end
