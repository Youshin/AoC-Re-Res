open Belt

type jumper = {
  curr: int,
  count: int,
}
module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = (a, b) => Pervasives.compare(a, b)
})

let input =
  Node.Fs.readFileAsUtf8Sync("./src/2017/input/day5.txt")
  ->Js.String2.split("\n")
  ->Array.mapWithIndex((idx, x) => (idx, x->int_of_string))
  ->Map.fromArray(~id=module(IntCmp))

// let s1 = Belt.Map.set(s0, 2, "3")

// Belt.Map.valuesToArray(s1) == ["1", "3", "3"]

let rec jumps_p1 = (maze, jumper: jumper) => {
  switch maze->Map.get(jumper.curr) {
  | None => jumper.count // escape
  | Some(jump) =>
    let newMaze = maze->Map.set(jumper.curr, jump + 1)

    jumps_p1(newMaze, {curr: jumper.curr + jump, count: jumper.count + 1})
  }
}

let rec jumps_p2 = (maze, jumper: jumper) => {
  switch maze->Map.get(jumper.curr) {
  | None => jumper.count // escape
  | Some(jump) =>
    let newMaze =
      jump >= 3 ? maze->Map.set(jumper.curr, jump - 1) : maze->Map.set(jumper.curr, jump + 1)

    jumps_p2(newMaze, {curr: jumper.curr + jump, count: jumper.count + 1})
  }
}

let jumps = (maze, jumper: jumper, part) => {
  if part == 1 {
    jumps_p1(maze, jumper)
  } else {
    jumps_p2(maze, jumper)
  }
}
let jumper1 = {
  curr: 0,
  count: 0,
}
let part1 = input->jumps(jumper1, 1)
part1->Js.log

let jumper2 = {
  curr: 0,
  count: 0,
}
let part2 = input->jumps(jumper2, 2)
part2->Js.log
