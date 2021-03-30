open Belt
let inputs =
  Node.Fs.readFileAsUtf8Sync("./src/2020/input/day1.txt")
  ->Js.String2.split("\n")
  ->Belt.Array.map(i => Belt.Int.fromString(i))
  ->Belt.Array.keepMap(x => x)

let part1 = (target, nums) => {
  nums
  ->Array.map(x => {
    nums->Array.keep(y => {
      target - x == y && x != y
    })
  })
  ->Array.concatMany
}
part1(2020, inputs)->Array.reduce(1, (acc, item) => acc * item)->Js.log

// let p2 = Belt.Array.map(inputs, x => {
//   Belt.Array.map(inputs, y => {
//     Belt.Array.map(inputs, z => {
//       (x, y, z)
//     })->Belt.Array.keep(((x, y, z)) => x + y + z === 2020)
//   })->Belt.Array.concatMany
// })->Belt.Array.concatMany

// let (p2X, p2Y, p2Z) = p2[0]
// Js.log(p2X * p2Y * p2Z)

let a = [1, 2, 3, 4, 5, 6]

let sum = a->Belt.Array.reduce(0, (acc, item) => acc + item)
