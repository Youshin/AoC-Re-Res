open Belt

type jumper = {
  curr: int,
  count: int,
}

let input =
  Node.Fs.readFileAsUtf8Sync("./src/2017/input/day5.txt")
  ->Js.String2.split("\n")
  ->Array.mapWithIndex((idx, x) => (idx, x->int_of_string))
  ->Map.Int.fromArray

let rec jumps = (maze, jumper, setMaze) => {
  switch maze->Map.Int.get(jumper.curr) {
  | None => jumper.count // escape
  | Some(jump) =>
    jumps(
      setMaze(maze, jump, jumper.curr),
      {curr: jumper.curr + jump, count: jumper.count + 1},
      setMaze,
    )
  }
}

let part1 = (maze, jump, curr) => {
  maze->Map.Int.set(curr, jump + 1)
}

let part2 = (maze, jump, curr) => {
  jump >= 3 ? maze->Map.Int.set(curr, jump - 1) : maze->Map.Int.set(curr, jump + 1)
}

let jumper = {
  curr: 0,
  count: 0,
}
let part1 = input->jumps(jumper, part1)
part1->Js.log

let part2 = input->jumps(jumper, part2)
part2->Js.log
