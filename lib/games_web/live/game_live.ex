defmodule GamesWeb.GameLive do
  use GamesWeb, :live_view
  import Ecto.Query
  alias Phoenix.Component, as: Live

  alias Games.Admin.Game
  alias Games.Admin.Puzzle

  def render(assigns) do
    component = assigns.game.slug
      |> String.split("_")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join()
    component = assigns.game.slug <> "/" <> component
    ~H"""
      <div class="mb-4">
        <h1>{assigns.game.name}</h1>
        <b>{assigns.game.title}</b><br/>
        <i>{assigns.game.date}</i>
      </div>
      <%= if @game.data != nil do %>
        <LiveSvelte.svelte name={component} props={%{game: @game.data}} />
      <% else %>
        no puzzle today :(
      <% end %>
    """
  end

  def mount(%{"id" => id, "date" => date}, _session, socket) do
    query =
      from g in Game,
        left_join: p in Puzzle, on: (g.id == p.game_id and p.date == ^date),
        where: g.slug == ^id,
        select: %{
          name: g.name,
          slug: g.slug,
          title: p.name,
          date: p.date,
          data: p.data
        }

    case Games.Repo.one(query) do
      nil ->
        {:ok, assign(socket, game: nil, error: "Game not found")}

      game ->
        data =
          case game.data do
            nil -> nil
            json -> Jason.decode!(json)
          end

      game = game
        |> Map.put(:data, data)
        |> Map.put_new(:title, "No puzzle available")
        |> Map.put_new(:date, nil)
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

  def handle_event("save_score", %{"score" => score}, socket) do
    {:noreply, Live.update(socket, :game, fn game -> Map.put(game, :puzzle_data, %{"score" => score}) |> IO.inspect end)}
  end


end
