defmodule GamesWeb.GameLive do
  use GamesWeb, :live_view

  alias Games.Admin
  alias Games.Admin.Game

  def render(assigns) do
    ~H"""
      <LiveSvelte.svelte name="Simple" props={%{game: @game, number: @number}} />
    """
  end

  def mount(params, _session, socket) do
    id = params["id"]
    game =   Admin.get_game_by!(id)

    {:ok, assign(socket, game: game.name, number: 5)}
  end

  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, assign(socket, :number, number)}
  end

end
