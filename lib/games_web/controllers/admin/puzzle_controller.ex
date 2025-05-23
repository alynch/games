defmodule GamesWeb.Admin.PuzzleController do
  use GamesWeb, :controller

  alias Games.Admin
  alias Games.Admin.Puzzle

  def new(conn, params) do
    changeset = Admin.change_puzzle(%Puzzle{}, params)
    |> IO.inspect(label: "NEW")
    render(conn, :new, changeset: changeset)
  end

def create(conn, %{"puzzle" => puzzle_params}) do
  case Admin.create_puzzle(puzzle_params) do
    {:ok, _puzzle} ->
      conn
      |> put_flash(:info, "Puzzle created successfully.")
      |> redirect(to: ~p"/admin/games/")

    {:error, %Ecto.Changeset{} = changeset} ->
      render(conn, :new, changeset: changeset)
  end
end

end
