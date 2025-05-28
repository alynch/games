<script>
    let {game, live} = $props()
    let n = $derived(game.n ?? 0)

    function increase() {
        live.pushEvent("set_number", {number: n + 1})
    }

    function decrease() {
        live.pushEvent("set_number", {number: n - 1})
    }
</script>

<p>The number is {n}</p>
<button class="px-4 border" onclick={increase}>+</button>
<button class="px-4 border" onclick={decrease}>-</button>

