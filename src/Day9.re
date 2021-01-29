open Belt;
open Summation;
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day9.txt")
  ->Js.String2.split("\n");

let preambleSize = 25;

module FloatOp = {
    type t = float;
    let add = (a:t, b:t) => a +. b;
    let substract = (a:t, b:t) => a -. b;
    let compare = (a:t, b:t) => a == b;
    let max_arr = arr => ArrayLabels.fold_left(~f=max, ~init=min_float, arr);
    let min_arr = arr => ArrayLabels.fold_left(~f=min, ~init=max_float, arr);
    let summation = arr => {
        arr->Array.reduce(0.0, (acc, item) => {
            acc +. item;
        });
    };
}

module FloatSummation = Summation(FloatOp);

let parse = (input: array(string)) => {
    input->Array.mapWithIndex( (idx ,x) => {
        input->Array.slice(~offset=idx, ~len=preambleSize)
        ->Array.map(str => str->float_of_string)
        // ->Array.map(x => x->float_of_int);
    })->Array.keep(x => x->Array.size == preambleSize);
}

// input->Js.log

let parsed = input->parse;
let targets_p1 = input->Array.sliceToEnd(preambleSize)
->Array.map(x => x->float_of_string);

// parsed->Js.log
// targets->Js.log

let solve = (targets) => {
    targets->Array.reduceWithIndex([||], (acc, target, idx) => {
        let nums = parsed->Array.getExn(idx);
        let a = FloatSummation.twoSum(target, nums);
        // a->Js.log
        if (a->Array.size == 0) {
            Array.concat(acc, [|target|]);
        }else {
            acc;
        }
    })->Array.getExn(0);
}

// part1 log
// targets_p1->solve->Js.log;

let targets_p2 = input->Array.map(x => x->float_of_string);
let p2_len = targets_p2->Array.length;

type weakness = {
    target: float,
    startIndex: int,
    endIndex: int,
    sum: float
};

let init = {
    target: targets_p1->solve,
    startIndex: 0,
    endIndex: 0,
    sum: 0.0
};
// targets_p2->Js.log;
let rec findWeakness = (state, target) => {
    if (state.target == state.sum) {
        let sliced = target->Array.slice(~offset=state.startIndex, ~len=state.endIndex - state.startIndex);
        sliced->FloatSummation.min +. sliced->FloatSummation.max
    }else {
        if(state.target > state.sum) {
            let item = target->Array.getExn(state.endIndex);
            findWeakness({...state, endIndex: state.endIndex+1 , sum: state.sum +. item}, targets_p2);
        }else {
            let item = target->Array.getExn(state.startIndex);
            findWeakness({...state, startIndex: state.startIndex + 1, sum: state.sum -. item}, targets_p2);
        }
    }
}

findWeakness(init, targets_p2)->Js.log;