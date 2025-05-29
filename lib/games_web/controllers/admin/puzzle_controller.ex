defmodule GamesWeb.Admin.PuzzleController do
  use GamesWeb, :controller

  alias Games.Admin
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


  def edit(conn, %{"id" => id}) do
    puzzle = Admin.get_puzzle!(id)
    changeset = Admin.change_puzzle(puzzle)
    render(conn, :edit, puzzle: puzzle, changeset: changeset)
  end


  def update(conn, %{"id" => id, "puzzle" => puzzle_params}) do
    puzzle = Admin.get_puzzle!(id)

    case Admin.update_puzzle(puzzle, puzzle_params) do
      {:ok, puzzle} ->
        conn
        |> put_flash(:info, "Puzzle updated successfully.")
        |> redirect(to: ~p"/admin/games/#{puzzle.game_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, puzzle: puzzle, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    puzzle = Admin.get_puzzle!(id)
    {:ok, _puzzle} = Admin.delete_puzzle(puzzle)

    conn
    |> put_flash(:info, "Puzzle deleted successfully.")
    |> redirect(to: ~p"/admin/games")
  end
end
