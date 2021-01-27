open Belt
let target = 2020

let input = Node.Fs.readFileAsUtf8Sync("./src/input/day1.txt")
->Js.String2.split("\n")
->Array.map(_val => _val->int_of_string)
->Array.reduce(Js.Dict.empty(), (arr, _val) => {
  arr->Js.Dict.set(_val->string_of_int, _val)
  arr
})

// Part 1
let keys = input->Js.Dict.keys->Js.Array2.map(a => a->int_of_string)

let res1 = keys->Js.Array2.filter(key =>
  switch input->Js.Dict.get(string_of_int(target - key)) {
  | Some(_) => true
  | None => false
  }
)

// Js.Dict는 Js Interop 할 때 주로 쓰니까, Belt Map 같은 걸 이용해보면 좋다.

// Part 2
let keys = input->Js.Dict.keys->Js.Array2.map(a => a->int_of_string)
let length = keys->Js.Array2.length
let res2 = {
  for i in 0 to length - 1 {
    for j in 1 to length {
      let v1 = keys->Array.get(i)
      let v2 = keys->Array.get(j)
      switch (v1, v2) {
      | (Some(v1), Some(v2)) => if v1 + v2 <= 2020 {
          let v = 2020 - v1 - v2
          if keys->Js.Array2.includes(v) {
            Js.log(v1 * v2 * v)
          }
        }
      | _ => ()
      }
    }
  }
}
