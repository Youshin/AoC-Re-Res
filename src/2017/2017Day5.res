open Belt

type jumper = {
  curr: int,
  count: int,
  maze: Belt.Map.Int.t<int>,
}

let input =
  Node.Fs.readFileAsUtf8Sync("./src/2017/input/day5.txt")
  ->Js.String2.split("\n")
  ->Array.mapWithIndex((idx, x) => (idx, x->int_of_string))
  ->Map.Int.fromArray

let nextState = (setMaze, state) => {
  let jump = state.maze->Map.Int.get(state.curr)->Option.getExn
  {
    maze: setMaze(state.maze, jump, state.curr),
    curr: state.curr + jump,
    count: state.count + 1,
  }
}

let rec action = (terminate, state, nextState') =>
  terminate(state) ? state : action(terminate, state->nextState', nextState')

let terminate = state => state.maze->Map.Int.get(state.curr) == None

let nextMap_p1 = (maze, jump, curr) => maze->Map.Int.set(curr, jump + 1)

let nextMap_p2 = (maze, jump, curr) =>
  jump >= 3 ? maze->Map.Int.set(curr, jump - 1) : maze->Map.Int.set(curr, jump + 1)

let nextStateP1 = nextState(nextMap_p1)
let nextStateP2 = nextState(nextMap_p2)

// let terminateState

let state = {
  maze: input,
  curr: 0,
  count: 0,
}
let part1 = terminate->action(state, nextStateP1)
part1.count->Js.log

let part2 = terminate->action(state, nextStateP2)
part2.count->Js.log
