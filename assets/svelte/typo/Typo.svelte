<script>
  import { onMount } from "svelte";
  import Word from "./Word.svelte";

  let {game, live} = $props();
  let wordList = [];
  let solution = $state(null);
  let startChain = $state([]);
  let endChain = $state([]);
  let newWord = $state("");
  let gameOver = $derived(startChain.length && endChain.length && startChain.at(-1) === endChain.at(-1));

  $effect(() => {
    if (gameOver) {
      const score = Math.round(solution?.length / (endChain.length + startChain.length - 1) * 100)
      live.pushEvent("save_score", {score})
    }
  })

  onMount(async () => {
    wordList = await fetch('/typo/words.json').then(x => x.json());
    const neighbours = await fetch('/typo/computed.txt')
      .then(r => r.text())
      .then(text => {
        const lines = text.split(/\r?\n/);
        const moves = new Map();
        for (const line of lines) {
          const [word, ...valid] = line.split(/[:,]/);
          moves.set(word, valid); // each move costs one for now
        }
        return moves;
      })

    let seedWords = wordList.filter(word => word.seed)
    startChain.push(game.start);
    endChain.push(game.end);
    solution = solve(startChain[0], endChain[0], neighbours)
    console.log($state.snapshot(startChain[0]) + " / "  + $state.snapshot(endChain[0]));
    console.debug($state.snapshot(solution))
    if (! solution) {
      console.log('%cNO SOLUTION', 'color: #DC6B6E; background: #FFF0EF');
    }
  });

  //FOR DEBUGGING
  // startChain.push("AILS");
  // endChain.push("RUTS");

  function submit(event) {
    if (event.key === "Enter") {
      let currentWord = newWord.toUpperCase().trim();
      newWord = "";

      if (wordList.every(word => word.word !== currentWord)) {
        console.log("%cINVALID WORD", 'color: #DC6B6E; background: #FFF0EF');
        return;
      }

      let startCompare = compareWords(startChain[startChain.length - 1], currentWord)
      let endCompare = compareWords(endChain[endChain.length - 1], currentWord)
      console.log(startChain.at(-1) + " → " + currentWord + " : " + startCompare.type + '\n' + endChain.at(-1) + " → " + currentWord + " : " + endCompare.type);

      if ((startCompare.type === "same" || startCompare.type === "invalid") && (endCompare.type === "same" || endCompare.type === "invalid")) {
      }
      
      if (startCompare.type !== "same" && startCompare.type !== "invalid") {
        startChain.push(currentWord);
      }
      
      if (endCompare.type !== "same" && endCompare.type !== "invalid") {
        endChain.push(currentWord);
      }
    }
  }

  function isInsertion(a, b) {
    let i = 0,
      j = 0,
      diff = 0;
    let index = null;

    while (j < b.length) {
      if (a[i] === b[j]) {
        i++;
        j++;
      } else {
        index = j++;
        diff++;
      }
    }
    return diff === 1 ? index : null
  }

  function compareWords(a, b) {
    let index = null;
    if (a.length === b.length) {
      if (a === b) {
        return { index, type: "same" }
      }

      if ([...a].sort().join("") === [...b].sort().join("")) {
        return { index, type: "shuffle" };
      }

      let diff = 0;
      for (let i = 0; i < a.length; i++) {
        if (a[i] != b[i]) {
          diff++;
          index = i;
        }
      }

      if (diff === 1) {
        return { index, type: "substitution" };
      }

    } else if (a.length < b.length) {
      if ((index = isInsertion(a, b)) !== null) {
        return { index, type: "insertion" }
      }
    } else { // a.length > b.length
      if ((index = isInsertion(b, a)) !== null) {
        return { index, type: "deletion" }
      }
    }

    return { index: null, type: "invalid" }
  }

  // SOLVER
/**
 * An implementation of A* to solve a Typo puzzle.
 * Supports substitutions, insertions, deletions, and shuffles.
 */
function a_star(start, goal, moves) {
  // index is estimated cost of solution along this path
  // value is array of words with the same estimate
  // (ideally this should actually be a heap or prio queue for efficiency)
  const edge = [[start]];
  const parents = (new Map).set(start, null);
  const costs = (new Map).set(start, 0);

  while (edge.filter(x => Array.isArray(x) && x.length > 0).length > 0) {
    const current = edge.find(x => Array.isArray(x) && x.length > 0)?.pop();
    if (current === goal) {
      break;
    }

    for (const move of moves.get(current) ?? []) {
      // all moves currently cost one
      const costSoFar = (costs.get(current)) + 1;
      const moveCost = costs.get(move);
      if (! costs.has(move) || costSoFar < moveCost) {
        costs.set(move, costSoFar);
        if (edge[costSoFar] === undefined) {
          edge[costSoFar] = [];
        }
        edge[costSoFar].push(move);
        parents.set(move, current);
      }
    }
  }

  return retrace(parents, goal);
}

/**
 * Given a goal state and a map of parent/previous states, return the array representing the path
 * from the start state to the end state. If no solution was found, return null.
 */
function retrace(parents, end) {
  if (! parents.has(end)) {
    return null; // no solution
  }

  const path = [];
  let current = end;
  while (parents.has(current)) {
    path.push(current);
    current = parents.get(current);
  }
  return path.reverse();
}

/**
 * Get the start and end words and solve the word ladder. Return the array of steps or null if no
 * solution is found. Assumes start and end are valid words.
 */
export function solve(start, end, moves) {
  const path = a_star(start, end, moves);

  if (path && path.length) {
    return path;
  } else {
    return null;
  }
}
</script>

<div class="chain">
  {#each startChain as word, index}
    {#if index === 0}
      <Word letters={word} edit={{ index: null, type: "start" }} />
      <div class="direction">↓</div>
    {:else}
      <div class="row">
        <Word letters={word} edit={compareWords(startChain[index - 1], word)} />
        {#if index === startChain.length - 1 && !gameOver}
          <button onclick={() => startChain.pop()}>X</button>
        {/if}
      </div>
    {/if}
  {/each}
</div>

{#if gameOver}
  <hr class="line"/>
  {console.log('SCORE:', Math.round(solution?.length / (endChain.length + startChain.length - 1) * 100) )}
{:else}
  <input bind:value={newWord} onkeydown={submit} disabled={!(startChain.length && endChain.length)} />
{/if}

<div class="chain">
  {#each endChain.toReversed() as word, index}
    {#if index === endChain.length - 1}
      <div class="direction">↑</div>
      <Word letters={word} edit={{ index: null, type: "start"}} />
    {:else if !gameOver || index}
      <div class="row">
        <Word letters={word} edit={compareWords(endChain.toReversed()[index + 1], word)} />
        {#if index === 0}
          <button onclick={() => endChain.pop()}>X</button>
        {/if}
      </div>
    {/if}
  {/each}
</div>

<style>
  :root{
    --border-color-light: #C9CAD6;
  --background-color-light: #F2F3FB;
  --black: #2E2F38;

  --border-radius-small: 6px;
  --border-radius-medium: 8px;
  }
  .chain {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
  }

  input {
    height: 32px;
    padding: 0 8px;
    margin: 0 auto;

    border: 1px solid var(--border-color-light);
    border-radius: var(--border-radius-medium);
    font-family: monospace;
    text-transform: uppercase;
    letter-spacing: 1rem;
    text-align: center;

    &:focus {
        border: 1px solid var( --black);
        outline: none;
    }
  }

  .direction {
      font-weight: bold;
  }

  .row {
    display: flex;
    align-items: center;
    position: relative;
    gap: 4px;
  }

  button {
    height: 24px;
    width: 24px;
    border-radius: var(--border-radius-small);
    border: none;
    background-color: white;
    color: var(--black);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
    font-family: var(--open-runde);

    position: absolute;
    left: calc(100% + 4px);

    &:hover {
      background-color: var(--background-color-light);
    }
  }

  .line {
    width: 400px;
    height: 1px;
    background: linear-gradient(90deg, white 10%, var(--border-color-light), white 90%);
    border: none;
    margin: 1px 0;
}
</style>