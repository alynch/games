defmodule GamesWeb.GameLive do
  use GamesWeb, :live_view
  import Ecto.Query
  alias Phoenix.Component, as: Live

  alias Games.Admin
  alias Games.Admin.Game
  alias Games.Admin.Puzzle

  def render(assigns) do
    ~H"""
      <LiveSvelte.svelte name="Simple" props={%{game: @game}} />
    """
  end

  def mount(params, _session, socket) do
    id = params["id"]
    date = params["date"]

    game = from g in Game,
      left_join: p in Puzzle, on: g.id == p.game_id,
      where: g.slug == ^id and p.date == ^date,
      select: %{game_name: g.name, puzzle_name: p.name, puzzle_date: p.date, puzzle_data: p.data}

    {:ok, game} = Games.Repo.one(game)
    |> Map.get_and_update(:puzzle_data, &Jason.decode/1)
    # |> IO.inspect()

    {:ok, assign(socket, game: game)}
  end

  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, Live.update(socket, :game, fn game -> Map.put(game, :puzzle_data, %{"n" => number}) |> IO.inspect end)}
  end

end
