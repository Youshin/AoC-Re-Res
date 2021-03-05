open Belt;

type bus = {
  num: int,
  offset: int,
  scaler: int,
};

let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day13_sample.txt")
  ->Js.String2.split("\n");

let parse = data => {
  let earliest = data->Array.getExn(0)->int_of_string;
  let buses =
    data
    ->Array.getExn(1)
    ->Js.String2.split(",")
    ->List.fromArray
    ->List.mapWithIndex((i, e) => {
        switch (e) {
        | "x" => None
        | _ =>
          Some({num: e->int_of_string, offset: i, scaler: e->int_of_string})
        }
      })
    ->List.keepMap(a => a);
  (earliest, buses);
};

let (earliest, buses) = input->parse;
let bus_head =
  buses
  ->List.map(n => (n.num, n.num - earliest mod n.num))
  ->List.sort(((_, sub1), (_, sub2)) => sub1 - sub2)
  ->List.get(0);

let get = (head) => {
    switch(head) {
        | Some((num, diff)) => (num, diff)
        | None => raise(Not_found)
    }
}
let (num, diff) = bus_head->get;
let part1 = num * diff;
part1->Js.log;

let rec solve = ((common, m), n, bus: bus) => {
  let timestamp = common +. m *. n;
  let num = bus.num->float_of_int;
  let offset = bus.offset->float_of_int;
  let result =
    offset == 0.0
      ? mod_float(timestamp, num) == 0.0
      : mod_float(timestamp, num) == num -. mod_float(offset, num);
  result ? (timestamp, m *. num) : solve((common, m), n +. 1.0, bus);
};
let (part2, _) =
  buses->List.reduce((0.0, 1.0), (acc, item: bus) => {
    solve(acc, 1.0, item)
  });

part2->Js.log;
