defmodule GamesWeb.GameLive do
  use GamesWeb, :live_view
  import Ecto.Query
  alias Phoenix.Component, as: Live

  alias Games.Admin.Game
  alias Games.Admin.Puzzle

  def render(assigns) do
    ~H"""
      <LiveSvelte.svelte name="Simple" props={%{game: @game}} />
    """
  end

  def mount(%{"id" => id, "date" => date}, _session, socket) do
    query =
      from g in Game,
        left_join: p in Puzzle, on: (g.id == p.game_id and p.date == ^date),
        where: g.slug == ^id,
        select: %{
          game_name: g.name,
          puzzle_name: p.name,
          puzzle_date: p.date,
          puzzle_data: p.data
        }

    case Games.Repo.one(query) do
      nil ->
        {:ok, assign(socket, game: nil, error: "Game not found")}

      game ->
        puzzle_data =
          case game.puzzle_data do
            nil -> nil
            json -> Jason.decode!(json)
          end

      game = game
        |> Map.put(:puzzle_data, puzzle_data)
        |> Map.put_new(:puzzle_name, "No puzzle available")
        |> Map.put_new(:puzzle_date, nil)
        |> IO.inspect(label: "GAME")

        {:ok, assign(socket, game: game)}
    end
  end

  def mount(params, session, socket) do
    date = Date.utc_today() |> Date.to_iso8601()
    mount(Map.put(params, "date", date), session, socket)
  end

  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, Live.update(socket, :game, fn game -> Map.put(game, :puzzle_data, %{"n" => number}) |> IO.inspect end)}
  end

end
