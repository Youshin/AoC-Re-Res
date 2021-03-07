open Belt

let input = Node.Fs.readFileAsUtf8Sync("./src/2017/input/day2.txt")

let parse = data => {
  let re = %re("/ |\t/")
  data
  ->Js.String2.split("\n")
  ->Array.map(x => x->Js.String2.splitByRe(re)->Array.map(x => x->Option.getExn->int_of_string))
}

let getMinMax = data => {
  let sorted = data->SortArray.Int.stableSort
  (sorted->Array.getExn(0), sorted->Array.getExn(sorted->Array.length - 1))
}

let modChecker = (x, y) => {
  if x > y {
    x->mod(y) == 0 ? x / y : 0
  } else if y > x {
    y->mod(x) == 0 ? y / x : 0
  } else {
    // self-modulo
    0
  }
}

let getModMatched = data => {
  let checked =
    data
    ->Array.map(x => {
      data->Array.reduce(0, (acc, item) => acc + modChecker(x, item))
    })
    ->Array.keep(x => x != 0)

  switch checked->Array.get(0) {
  | Some(x) => x
  | None => 0
  }
}

let part1 =
  input
  ->parse
  ->Array.map(x => x->getMinMax)
  ->Array.map(x => {
    let (min, max) = x
    max - min
  })
  ->Array.reduce(0, (acc, item) => acc + item)

part1->Js.log

let part2 =
  input->parse->Array.map(x => x->getModMatched)->Array.reduce(0, (acc, item) => acc + item)

part2->Js.log
