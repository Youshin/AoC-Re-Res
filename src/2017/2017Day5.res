open Belt

type jumper = {
  maze: array<int>,
  curr: int,
  count: int,
}

let input =
  Node.Fs.readFileAsUtf8Sync("./src/2017/input/day5.txt")
  ->Js.String2.split("\n")
  ->Array.map(x => x->int_of_string)

let rec jumps = (jumper: jumper, part: int) => {
  switch jumper.maze->Array.get(jumper.curr) {
  | None => jumper.count // escape
  | Some(jump) => {
      switch part == 1 {
      | true =>
        let _ = jumper.maze->Array.set(jumper.curr, jump + 1)
      | _ =>
        let _ =
          jump >= 3
            ? jumper.maze->Array.set(jumper.curr, jump - 1)
            : jumper.maze->Array.set(jumper.curr, jump + 1)
      }
      jumps({...jumper, curr: jumper.curr + jump, count: jumper.count + 1}, part)
    }
  }
}
let jumper1 = {
  maze: input,
  curr: 0,
  count: 0,
}
let part1 = jumper1->jumps(1)
part1->Js.log

let jumper2 = {
  maze: input,
  curr: 0,
  count: 0,
}
let part2 = jumper2->jumps(2)
part2->Js.log
