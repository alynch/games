defmodule GamesWeb.Admin.PuzzleHTML do
  use GamesWeb, :html

  embed_templates "puzzle_html/*"

  @doc """
  Renders a game form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def puzzle_form(assigns)
end
