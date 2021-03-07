open Belt

let input = Node.Fs.readFileAsUtf8Sync("./src/2017/input/day1.txt")->Js.String2.split("")

let parse = (data, step) => {
  // keep only matching numbers
  data
  ->Array.mapWithIndex((idx, item) => {
    switch data[mod(idx + step, data->Array.length)] {
    | Some(next) when item == next => item->Int.fromString
    | Some(_)
    | None =>
      None
    }
  })
  ->Array.keepMap(x => x)
}

let part1 = input->parse(1)->Array.reduce(0, (acc, item) => acc + item)
part1->Js.log

let part2 = input->parse(input->Array.length / 2)->Array.reduce(0, (acc, item) => acc + item)
part2->Js.log
