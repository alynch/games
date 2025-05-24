defmodule GamesWeb.Admin.PuzzleController do
  use GamesWeb, :controller

  alias Games.Admin
  alias Games.Admin.Game
  alias Games.Admin.Puzzle

  def new(conn, params) do
    changeset = Admin.change_puzzle(%Puzzle{}, params)
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"game_id" => game_id, "puzzle" => puzzle_params}) do
    game = Admin.get_game!(game_id) # Assuming a context module like Games

    case Admin.create_puzzle(game, puzzle_params) do
      {:ok, _puzzle} ->
        conn
        |> put_flash(:info, "Puzzle created successfully.")
        |> redirect(to: ~p"/admin/games/#{game.slug}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, game: game)
    end
  end
end
