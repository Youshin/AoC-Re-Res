open Belt
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day1.txt");

let parse = (data) => {
	data->Js.String2.split("\n")
  ->Array.reduce(Map.String.empty, (acc, n) => 
    acc->Map.String.set(n, n->int_of_string))
};

let res1 = (nums, target) => {
	nums->Map.String.reduce((0, 0), (acc, _, v) => {
	  switch nums->Map.String.get((target - v)->string_of_int) {
	  | Some(found) => (v, found)
	  | None => acc
	  }
	})
}

// reduce를 끝까지 안돌기 위해서
// 1. rec 함수
// 2. findFirstBy https://rescript-lang.org/docs/manual/v8.0.0/api/belt/map-string#findfirstby

input->parse->res1(2020)->Js.log