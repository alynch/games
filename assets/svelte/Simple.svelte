<script>
    /** @type {{number: any, live: any}} */
    let {game, number, live} = $props()

    function increase() {
        live.pushEvent("set_number", {number: number + 1})
    }

    function decrease() {
        live.pushEvent("set_number", {number: number - 1})
    }
</script>

<h1>{ game }</h1>

<p>The number is {number}</p>

<button onclick={increase}>+</button>
<button onclick={decrease}>-</button>
