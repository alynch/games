<script>
    let {game, live} = $props()

    function increase() {
        live.pushEvent("set_number", {number: game.puzzle_data.n + 1})
    }

    function decrease() {
        live.pushEvent("set_number", {number: game.puzzle_data.n - 1})
    }
</script>

<h1>{ game.game_name }</h1>

<p>The number is {game.puzzle_data.n}</p>

<button class="px-4 border" onclick={increase}>+</button>
<button class="px-4 border" onclick={decrease}>-</button>
