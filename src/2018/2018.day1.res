open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/2018/input/day1.txt")

let parse = data => data->Js.String2.split("\n")

let preprocess = data => data->Array.map(i => Int.fromString(i))->Array.keepMap(x => x)

let apply = data => data->Array.reduce(0)
let summation = data => data->apply(\"+")

let part1 = input->parse->preprocess->summation
part1->Js.log

type state = {
  data: array<int>,
  index: int,
  history: list<int>,
}

let terminate = (state, current) => state.history->Belt.List.some(x => x == current) == true

let rec next = (state: state, sum, terminateFn) => {
  let size = state.data->Array.length
  let current = state.data->Array.getExn(state.index->mod(size)) + sum
  state->terminateFn(current)
    ? current
    : next(
        {...state, index: state.index + 1, history: list{current, ...state.history}},
        current,
        terminateFn,
      )
}

let nextState = data => {data: data, index: 0, history: list{}}->next(0, terminate)

let part2 = input->parse->preprocess->nextState

part2->Js.log
