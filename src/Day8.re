open Belt
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day8.txt")
  ->Js.String2.split("\n")->List.fromArray;

type register = {
    acc: int, 
    history: list(int), 
    success: bool
};

let init = {
    acc: 0, 
    history: [], 
    success: false
}

type instruction = NOP(int) | ACC(int) | JMP(int) | UNK;

let parse = input->List.map(l => {
  let splited = l->Js.String2.split(" ")->List.fromArray;
  let num = splited->List.getExn(1)->int_of_string;
  switch (splited->List.get(0)) {
      | Some("nop") => NOP(num)
      | Some("acc") => ACC(num)
      | Some("jmp") => JMP(num)
      | _ => UNK
  };
});

let checkFailure = (state, curr) => {
    if (curr < 0) {
        true;
    } else if (state.history->List.some(i => i == curr)) {
        true;
    } else {
        false;   
    }
}

// Option
// Result
// Either

let rec run = (instructions, curr, state) => {
    if (checkFailure(state, curr)) {
        {...state, success: false} // Belt.Result.t -> Belt.Result.Ok | Belt.Result.Error
    }else if (instructions->List.length <= curr) {
        {...state, success: true}
    } else {
        let state = {...state,  history: state.history->List.concat([curr])};


        switch (instructions->List.getExn(curr)) {
        | UNK => run(instructions, curr + 1, state)
        | NOP(_) => run(instructions, curr + 1, state)
        | ACC(i) => run(instructions, curr + 1, {...state, acc: state.acc + i})
        | JMP(i) => run(instructions, curr + i, state)
        }
    }
}

// let part1 = parse->run(0, init)
// part1.acc->Js.log

// part 2
let shift_inst = (insts, inst, idx) => {
    List.fromArray(Array.concatMany([| insts->List.toArray->Array.slice(~offset=0,~len=idx), [|inst|], insts->List.toArray->Array.sliceToEnd(idx+1) |]));
}
let reverse_inst = (inst) => switch inst {
    | NOP(i) => JMP(i)
    | JMP(i) => NOP(i)
    | _ => inst
};

let processed = parse->run(0, init).history

let part2 = processed->List.reduce(init, (state, i) => {
    let inst = parse->List.getExn(i);
    let reversed_inst = inst->reverse_inst;
    switch reversed_inst {
        | ACC(_) => state
        | _ => 
        if (state.success) {
            state;
        } else {
            let new_processed = shift_inst(parse, reversed_inst, i)->run(0, init)
            if (new_processed.success) {
                new_processed
            }else {
                state;
            }            
        }
    };
});

part2.acc->Js.log
// history