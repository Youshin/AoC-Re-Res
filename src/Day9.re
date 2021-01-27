open Belt;

let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day9_sample.txt")
  ->Js.String2.split("\n");

type preamble_set = {
    target: int,
    ambles: array(int),
    size: int
}

let init = {
    target: 0,
    ambles: [||],
    size: 5
}

let parse = (input: array(string)) => {
    input->Array.mapWithIndex( (idx ,x) => {
        input->Array.slice(~offset=idx, ~len=5)
        ->Array.map(str => str->int_of_string)
        ->SortArray.Int.stableSort;
    })->Array.keep(x => x->Array.size == 5);
}
// input->Js.log
let parsed = input->parse->Js.log;

let calc = (target: int, sorted_input: array(int)) => {
    sorted_input->Array.map(x => {
        sorted_input->Array.keep(y => {
            target-x == y && x != y;
        })
    });
}

calc(40, [|15,20,25,35,47|])->Js.log;
