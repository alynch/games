defmodule GamesWeb.Admin.GameController do
  use GamesWeb, :controller

  alias Games.Admin
  alias Games.Admin.Game

  def index(conn, _params) do
    games = Admin.list_games()
    render(conn, :index, games: games)
  end

  def new(conn, _params) do
    changeset = Admin.change_game(%Game{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    case Admin.create_game(game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: ~p"/admin/games/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do

    game = Admin.get_game_by!(id)
    render(conn, :show, game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Admin.get_game_by!(id)
    changeset = Admin.change_game(game)
    render(conn, :edit, game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Admin.get_game!(id)

    case Admin.update_game(game, game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: ~p"/admin/games/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Admin.get_game!(id)
    {:ok, _game} = Admin.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: ~p"/games")
  end
end
