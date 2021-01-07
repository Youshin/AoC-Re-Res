open Belt

let input = Node.Fs.readFileAsUtf8Sync("./input/input_sample.txt")->Js.String2.split("\n")
  ->Belt.Array.map(_val => _val->int_of_string)
  ->Belt.Array.reduce(Js.Dict.empty(), (arr, _val) => {
        arr->Js.Dict.set(_val->string_of_int, _val);
        arr;
      },
    );

let target = 2020


// Part 1
let keys = input->Js.Dict.keys->Js.Array2.map(a=>a->int_of_string)

let res1 = 
  keys->Js.Array2.filter(
    key => 
    switch(input->Js.Dict.get(string_of_int(target - key))) {
      | Some(exist) => {
        true
      }
      | None => false
    }
  );
res1->Array.reduce(1, (a, b) => a * b)->Js.log


// Part 2
