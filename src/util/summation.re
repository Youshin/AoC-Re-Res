// module type floatable = {
//     type t;
//     let toFloat: (t) => float;
// };
open Belt;
module type generics = {
    type t;
    let add: (t,t) => t;
    let substract: (t,t) => t;
    let compare: (t,t) => bool; // Pervasives.compare, https://reasonml.github.io/api/Pervasives.html
    let max_arr: array(t) => t;
    let min_arr: array(t) => t;
    let summation: array(t) => t;
};

module Summation = (Item: generics) => {
    type t = Item.t;
    let sum = (a: t, b: t) => {
        Item.add(a,b)
    };
    let print = (t: t) => {
        t->Js.log;
    }

    let twoSum = (target: t, nums: array(t)) => {
        nums->Array.map(x => {
            nums->Array.keep(y => {
                Item.compare(Item.substract(target,x), y) && !Item.compare(x,y);
            })
        })
        ->Array.keep(x=> x->Array.length != 0);
    };

    let threeSum = () => {
    }

    let max = (arr) => {
        Item.max_arr(arr);
    }

    let min = (arr) => {
        Item.min_arr(arr);
    }

    let sum = (arr) => {
        Item.summation(arr);
    }
};


module IntSummation = Summation({
    type t = int;
    let add = (a, b) => a + b;
    let substract = (a, b) => a - b;
    let compare = (a, b) => a == b;
    let max_arr = arr => ArrayLabels.fold_left(~f=max, ~init=min_int, arr);
    let min_arr = arr => ArrayLabels.fold_left(~f=min, ~init=max_int, arr);
    let summation = arr => {
        arr->Array.reduce(0, (acc, item) => {
            acc + item;
        });
    }
});

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
// module StringSummation = Summation({
//     type t = int;
//     let add = (a:t, b:t) => (a->string_of_int ++ b->string_of_int)->int_of_string;
// });

// FloatSummation.sum(1.5, 2.0)->FloatSummation.print;

// FloatSummation.twoSum(40.0, [|15.0,20.0,25.0,35.0,47.0|])->Js.log;

// IntSummation.sum(1, 2)->IntSummation.print;

// StringSummation.sum(1,2)->StringSummation.print;
// module FloatSummation = Summation({
//     type t = float;
//     let toFloat = float_of_int;
//     let add: (t, t) => float;
// });