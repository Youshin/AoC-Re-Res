open Belt

let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day10.txt")
  ->Js.String2.split("\n")->Array.map(x => x->int_of_string)
  ->SortArray.Int.stableSort;

let maxJolt = input->Array.getExn(input->Array.length-1);

let data = Array.concatMany([| [|0|], input, [|maxJolt+3|] |]);

type jolt = {
    jolt_1: int,
    jolt_3: int
}

let init = {
    jolt_1: 0,
    jolt_3: 0
}

let calculateJolt = (data) => {
    let res = data->Array.reduceWithIndex(init, (acc, item, idx) => {
        if(idx == 0) {
            init
        }else {
            switch (data->Array.get(idx-1)) {
                | Some(x) when x + 1 == item => {...acc, jolt_1: 1 + acc.jolt_1};
                | Some(x) when x + 3 == item => {...acc, jolt_3: 1 + acc.jolt_3};
                | _ => init;
            }
        }
    });
    res.jolt_3 * res.jolt_1;
};

let part1 = data->calculateJolt->Js.log

type arrange = {
    jolt_1: int,
    arrange: float,
}

let arrange_init = {
    jolt_1: 0,
    arrange: 1.0
}

let calcArrange = (data) => {
    let res = data->Array.reduceWithIndex(arrange_init, (acc, item, idx) => {
        if(idx == 0) {
            arrange_init;
        }else {
            switch (data->Array.get(idx-1)) {
                | Some(x) when x + 1 == item => {...acc, jolt_1: 1 + acc.jolt_1};
                | Some(x) when x + 3 == item => {
                    let exp = (acc.jolt_1 - 1) < 0 ? 0 : acc.jolt_1 - 1;
                    let offset = (acc.jolt_1 == 4) ? 1.0 : 0.0;
                    
                    let arrange = Js.Math.pow_int(~base=2, ~exp=exp)->float_of_int -. offset;
                    {jolt_1: 0, arrange: acc.arrange *. arrange}
                    };
                | _ => arrange_init;
            }
        }
    });
    res;
};

// data->Js.log;

data->calcArrange.arrange->Js.log;


// 0,  1,  3,  4,  5,  6, 7, 10, 11, 12, 15, 16, 19, 22

// 3 4 5 6 7

// 3 4 5 6
// 4 5 6 7

// 3 4 5 6 7
// 3 4 5 7
// 3 5 6 7
// 3 4 7
// 3 5 7
// 3 6 7
