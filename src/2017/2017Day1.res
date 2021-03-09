open Belt

let input =
  Node.Fs.readFileAsUtf8Sync("./src/2017/input/day1.txt")
  ->Js.String2.split("")
  ->Array.map(int_of_string)

let parse = (data, step) => {
  data->Array.keepWithIndex((item, idx) =>
    data->Array.getExn(mod(idx + step, data->Array.length)) == item
  )
}

let part1 = input->parse(1)->Array.reduce(0, (acc, item) => acc + item)
part1->Js.log

let part2 = input->parse(input->Array.length / 2)->Array.reduce(0, (acc, item) => acc + item)
part2->Js.log
