open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/input/day3.txt")->Js.String2.split("\n")
let parsed_input = input->Array.reduce("", (acc, item) => acc ++ item)->Js.String2.split("")
let length = parsed_input->Array.length

let height = input->Array.length
let width = input->Array.getExn(0)->Js.String2.length
let slopes = [(1,1),(3,1),(5,1),(7,1),(1,2)] // (right, down)

let validate = ch => {
  if ch == "#" {
    true
  } else {
    false
  }
}

let rec traverse = (slope, (curr_x,curr_y), acc) => {
  let (x,y) = slope
  let index = mod(curr_x,width) + (curr_y * width)
  switch parsed_input->Array.get(index) {
    | Some(_val) => {
      // _val->Js.log
      let new_acc = acc ++ _val
      traverse(slope, (curr_x+x, curr_y+y), new_acc)
    }
    | None => acc
  } 

}
let part1 = traverse((3,1), (0,0), "")
  ->Js.String2.castToArrayLike->Js.Array2.fromMap(x => x)
  ->Js.Array2.filter(validate)
  ->Js.Array2.length
  ->Js.log
  
let part2 = slopes->Array.reduce(
  1.0, (acc, item) => 
  acc *. traverse(item, (0,0), "")
  ->Js.String2.castToArrayLike->Js.Array2.fromMap(x => x)
  ->Js.Array2.filter(validate)
  ->Js.Array2.length->Js.Int.toFloat
)->Js.log