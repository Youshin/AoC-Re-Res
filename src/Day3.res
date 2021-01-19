open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/input/day3.txt")->Js.String2.split("\n")
let parsed_input = input->Array.reduce("", (acc, item) => acc ++ item)->Js.String2.split("")
let length = parsed_input->Array.length

let height = input->Array.length
let width = input->Array.getExn(0)->Js.String2.length
// let slopes = [(1,1),(3,1),(5,1),(7,1),(1,2)] // (right, down)
// -> [{x: 1, y: 1} ... ]

type coord_t = {x: int, y: int};
let move = (a: coord_t, b:coord_t)=> {x: a.x + b.x, y: a.y + b.y}

let slopes = [{x:1,y:1},{x:3,y:1},{x:5,y:1},{x:7,y:1},{x:1,y:2}]

let validate = ch => ch == "#"


let rec traverse = (slope, coord: coord_t, acc) => {
  // let (x,y) = slope
  let index = mod(coord.x,width) + (coord.y * width)
  switch parsed_input->Array.get(index) {
    | Some(_val) => {
      // _val->Js.log
      let new_acc = acc ++ _val
      traverse(slope, move(slope, coord), new_acc)
    }
    | None => acc
  } 
}



let solution = item => traverse(item, {x:0, y:0}, "")
  ->Js.String2.castToArrayLike->Js.Array2.fromMap(x => x)
  ->Js.Array2.filter(validate)
  ->Js.Array2.length

let part1 = solution({x:3,y:1});
  
let part2 = slopes
            ->Array.map(coord => solution(coord))
            ->Array.map(v => Js.Int.toFloat(v))
            ->Array.reduce(1.0, (acc, item) => acc *. item);
part1->Js.log
part2->Js.log