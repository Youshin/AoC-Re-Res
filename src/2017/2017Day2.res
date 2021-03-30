// open Belt

// let input = Node.Fs.readFileAsUtf8Sync("./src/2017/input/day2_sample.txt")

// let parse = data => {
//   let re = %re("/ |\t/")
//   data
//   ->Js.String2.split("\n")
//   ->Array.map(x => x->Js.String2.splitByRe(re)->Array.map(x => x->Option.getExn->int_of_string))
// }

// // let part1 = rows => rows->Array.map(x => Set.Int.diff(x->Set.Int.maximum, x->Set.Int.minimum))

// // input->parse->part1

// // flatmap(modchecker)->keepmap(modmatched)

// let getMinMax = data => {
//   let sorted = data->SortArray.Int.stableSort
//   (sorted->Array.getExn(0), sorted->Array.getExn(sorted->Array.length - 1))
// }

// let modChecker = (x, y) => {
//   if x > y {
//     x->mod(y) == 0 ? x / y : 0
//   } else if y > x {
//     y->mod(x) == 0 ? y / x : 0
//   } else {
//     // self-modulo
//     0
//   }
// }

// let checker = (value, fn) => {
//   Option.flatMap(value, fn)
// }

// let getModMatched = data => {
//   let checked = data->Array.keepMap(x => {
//     let res = data->Array.reduce(0, (acc, item) => acc + modChecker(x, item))
//     res == 0 ? None : Some(res)
//   })
//   checked->Js.Array.pop->Belt.Option.getWithDefault(0)
//   switch checked->Js.Array.pop {
//   | Some(x) => x
//   | None => 0
//   }
// }

// let part1 =
//   input
//   ->parse
//   ->Array.map(x => x->getMinMax)
//   ->Array.map((min, max) => max - min)
//   ->Array.reduce(0, (acc, item) => acc + item)
// part1->Js.log

// let part2 =
//   input->parse->Array.map(x => x->getModMatched)->Array.reduce(0, (acc, item) => acc + item)

// part2->Js.log

// input->parse->Js.log

