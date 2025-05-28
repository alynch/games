<script>
    let {game, live} = $props()
    let n = $derived(game.puzzle_data?.n ?? 0)

    function increase() {
        live.pushEvent("set_number", {number: n + 1})
    }

    function decrease() {
        live.pushEvent("set_number", {number: n - 1})
    }
</script>

<h1 class="text-lg font-semibold text-zinc-800">Game: { game.game_name }</h1>


{#if game.puzzle_date}
  <h1>Puzzle: { game.puzzle_name }</h1>
  <h1>Date: { game.puzzle_date }</h1>


  <p>The number is {n}</p>

  <button class="px-4 border" onclick={increase}>+</button>
  <button class="px-4 border" onclick={decrease}>-</button>

{:else}
	<p>No puzzle for this date</p>
{/if}

