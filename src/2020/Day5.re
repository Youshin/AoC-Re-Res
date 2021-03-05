open Belt;
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day5.txt")->Js.String2.split("\n");

type lohi = {
  lo: int,
  hi: int,
};
let avg = (a, b) => (a + b)->float_of_int /. 2->float_of_int;

type matrix = {
  row: lohi,
  col: lohi,
};

let row = {lo: 0, hi: 127};
let col = {lo: 0, hi: 7};

let start = {row, col};

let splitWords = words => {
  words->Js.String2.split("");
};

let getSeatID = matrix => matrix.row.hi * 8 + matrix.col.hi;

// https://rescript-lang.org/docs/manual/latest/api/js/math#minmany_int
// OCaml ArrayLabels보다 Belt.Array에서 방법 찾기
let max_arr = arr => ArrayLabels.fold_left(~f=max, ~init=min_int, arr);
let min_arr = arr => ArrayLabels.fold_left(~f=min, ~init=max_int, arr);

let numeric = (n1, n2) => n1 - n2;
// where F means "front", B means "back", L means "left", and R means "right".

/*
     Start by considering the whole range, rows 0 through 127.
     F means to take the lower half, keeping rows 0 through 63.
     B means to take the upper half, keeping rows 32 through 63.
     F means to take the lower half, keeping rows 32 through 47.
     B means to take the upper half, keeping rows 40 through 47.
     B keeps rows 44 through 47.
     F keeps rows 44 through 45.
     The final F keeps the lower of the two, row 44.

     Start by considering the whole range, columns 0 through 7.
     R means to take the upper half, keeping columns 4 through 7.
     L means to take the lower half, keeping columns 4 through 5.
     The final R keeps the upper of the two, column 5.
 */

// 내장 ceil 보다 Js.Math.ceil 우선 고려
let takeAction = (word, curr: matrix) => {
  switch (word) {
  | "B" =>
    let low = avg(curr.row.hi, curr.row.lo)->Js.Math.ceil_int;
    {
      ...curr, // 꿀팁
      row: {
        lo: low,
        hi: curr.row.hi,
      },
    };
  | "F" =>
    let hi = avg(curr.row.hi, curr.row.lo)->floor->int_of_float;
    {
      row: {
        lo: curr.row.lo,
        hi,
      },
      col: curr.col,
    };
  | "R" =>
    let low = avg(curr.col.hi, curr.col.lo)->ceil->int_of_float;
    {
      col: {
        lo: low,
        hi: curr.col.hi,
      },
      row: curr.row,
    };
  | "L" =>
    let hi = avg(curr.col.hi, curr.col.lo)->floor->int_of_float;
    {
      col: {
        lo: curr.col.lo,
        hi,
      },
      row: curr.row,
    };
  | _ => {col: curr.col, row: curr.row}
  };
};
let parse = words => {
  words->Array.reduce(
    start,
    (pos, data) => {
      let new_data = data->takeAction(pos);
      // new_data->Js.log
      new_data;
    },
  );
};
let findMySeat = seats => {
  seats->Array.keep(x => !seats->Js.Array2.includes(x + 1))->Array.getExn(0)
  + 1;
};
let part1 =
  input->Array.map(x => x->splitWords->parse->getSeatID)->max_arr->Js.log;

// Belt.SortArray.Int
let part2 =
  input
  ->Array.map(x => x->splitWords->parse->getSeatID)
  ->Js.Array2.sortInPlaceWith(numeric)
  ->findMySeat
  ->Js.log;
