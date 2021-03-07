open Belt

let input =
  Node.Fs.readFileAsUtf8Sync("./src/2017/input/day5.txt")
  ->Js.String2.split("\n")
  ->Array.map(x => x->int_of_string)

let rec jumps = (maze, idx, count, part) => {
  switch maze->Array.get(idx) {
  | None => count // escape
  | Some(jump) => {
      switch part == 1 {
      | true =>
        let _ = maze->Array.set(idx, jump + 1)
      | _ =>
        let _ = jump >= 3 ? maze->Array.set(idx, jump - 1) : maze->Array.set(idx, jump + 1)
      }
      jumps(maze, idx + jump, count + 1, part)
    }
  }
}

let part1 = input->Array.copy->jumps(0, 0, 1)
part1->Js.log

let part2 = input->Array.copy->jumps(0, 0, 2)
part2->Js.log
