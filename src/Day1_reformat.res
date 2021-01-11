open Belt
let mapOfInput =
  Node.Fs.readFileAsUtf8Sync("./src/input/input_sample.txt")
  ->Js.String2.split("\n")
  ->Array.reduce(Map.String.empty, (acc, n) => acc->Map.String.set(n, n->int_of_string))

Js.log(mapOfInput)
let target = 2020

let res1 = mapOfInput->Map.String.reduce((0, 0), (acc, _, v) => {
  switch mapOfInput->Map.String.get((target - v)->string_of_int) {
  | Some(found) => (v, found)
  | None => acc
  }
})

res1->Js.log