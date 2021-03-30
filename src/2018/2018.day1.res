open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/2018/input/day1.txt")

let parse = data => data->Js.String2.split("\n")

let preprocess = data => data->Array.map(i => Int.fromString(i))->Array.keepMap(x => x)

type state = {
  data: array<int>,
  index: int,
  history: list<int>,
}
let terminateP1 = (state, curr) => state.index == state.data->Array.length - 1
let terminateP2 = (state, curr) => state.history->List.some(x => x == curr) == true

let rec next = (state: state, sum, terminateFn) => {
  let size = state.data->Array.length
  let curr = state.data->Array.getExn(state.index->mod(size)) + sum
  state->terminateFn(curr)
    ? curr
    : next(
        {...state, index: state.index + 1, history: list{curr, ...state.history}},
        curr,
        terminateFn,
      )
}

let nextState = data => {data: data, index: 0, history: list{}}->next(0)

let part1 = input->parse->preprocess->nextState(terminateP1)
part1->Js.log
let part2 = input->parse->preprocess->nextState(terminateP2)
part2->Js.log
