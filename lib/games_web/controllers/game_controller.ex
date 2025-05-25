defmodule GamesWeb.GameController do
  use GamesWeb, :controller

  import Ecto.Query

  alias Games.Admin
  alias Games.Admin.Game

  def archive(conn, %{"id" => id}) do
    game = Admin.get_game_by!(id)
    |> IO.inspect
    render(conn, :archive, game: game)
  end

  def show(conn, %{"id" => id, "date" => date}) do

    today = Calendar.strftime(Date.from_iso8601!(date), "%Y-%m-%d")

    case get_game_and_one_puzzle_by_game_slug_and_puzzle_date(id, today) do
      {game, nil} ->
          render(conn, :nopuzzle, game: game, today: today)
      {game, puzzle} ->
          render(conn, :show, game: game, puzzle: puzzle, today: today)
      nil ->
          render(conn, :nogame)
    end
  end

  def show(conn, %{"id" => id}) do

    today = Calendar.strftime(Date.utc_today, "%Y-%m-%d")


    case get_game_and_one_puzzle_by_game_slug_and_puzzle_date(id, today) do
      {game, nil} ->
          render(conn, :nopuzzle, game: game, today: today)
      {game, puzzle} ->
          render(conn, :show, game: game, puzzle: puzzle, today: today)
      nil ->
          render(conn, :nogame)
    end
  end

  def get_game_and_one_puzzle_by_game_slug_and_puzzle_date(slug, date) do
    from(g in Game,
      where: g.slug == ^slug,
      left_join: p in assoc(g, :puzzles),
      on: p.date == ^date,
      order_by: [asc: p.inserted_at],
      limit: 1,
      select: {g, p}
    )
    |> Games.Repo.one()
    |> IO.inspect
  end

end
