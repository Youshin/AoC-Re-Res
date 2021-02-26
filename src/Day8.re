open Belt;
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day8.txt")
  ->Js.String2.split("\n")
  ->List.fromArray;
type success =
  | DONE
  | FAIL
  | INIT;

type state = {
  acc: int,
  history: list(int),
  success,
};

let init_state = {acc: 0, history: [], success: INIT};

type instruction =
  | NOP(int)
  | ACC(int)
  | JMP(int);

// ks: from?
// List 대신 Array가 더 맞는 자료구조인 것 같음. 왜냐하면 Random Access와 고정 사이즈임
let parse = input =>
  input->List.map(l => {
    let splited = l->Js.String2.split(" ")->List.fromArray;
    let num = splited->List.getExn(1)->int_of_string;
    switch (splited->List.get(0)) {
    | Some("nop") => NOP(num)
    | Some("acc") => ACC(num)
    | Some("jmp") => JMP(num)
    | _ => raise(Not_found)
    };
  });

// ks: 1줄
let checkFailure = (state, curr) =>
  curr < 0 || state.history->List.some(i => i == curr);

let nextState = (instructions, curr, state) =>
  if (instructions->List.length <= curr) {
    (instructions, curr, {...state, success: DONE});
  } else {
    let state = {...state, history: state.history->List.add(curr)};
    switch (instructions->List.getExn(curr)) {
    | NOP(_) => (instructions, curr + 1, state)
    | ACC(i) => (instructions, curr + 1, {...state, acc: state.acc + i})
    | JMP(i) => (instructions, curr + i, state)
    };
  };

let rec run = (instructions, terminateFn, curr, state) => {
  let (_, curr', state') = instructions->nextState(curr, state);
  //   state'->Js.log;
  if (checkFailure(state', curr')) {
    {...state, success: FAIL};
  } else {
    terminateFn(state')
      ? state' : run(instructions, terminateFn, curr', state');
  };
};

let terminateFn_part1 = s => s.success == FAIL;
let part1 = input->parse->run(terminateFn_part1, 0, init_state);
part1.acc->Js.log;

let shift_inst = (insts, inst, idx) => {
  let res = insts->List.toArray;
  let _ = res->Array.set(idx, inst);
  res->List.fromArray;
};

let reverse_inst = inst =>
  switch (inst) {
  | NOP(i) => JMP(i)
  | JMP(i) => NOP(i)
  | _ => inst
  };

let processed_history =
  input->parse->run(terminateFn_part1, 0, init_state).history;
let terminateFn_part2 = s => s.success == DONE;

let rec traverse = (input, history, state, idx) =>
  if (state.success == DONE) {
    state;
  } else {
    let inst = input->parse->List.getExn(idx);
    let reversed_inst = inst->reverse_inst;

    switch (reversed_inst) {
    | ACC(_) => traverse(input, history, state, idx + 1)
    | _ =>
      let new_processed =
        shift_inst(input->parse, reversed_inst, idx)
        ->run(terminateFn_part2, 0, init_state);
      new_processed.success == DONE
        ? traverse(input, history, new_processed, idx + 1)
        : traverse(input, history, state, idx + 1);
    };
  };

let part2 = traverse(input, processed_history, init_state, 0);

part2.acc->Js.log;
