open Belt;
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day7.txt")
  ->Js.String2.split("\n")
  ->List.fromArray;

type contain = {
  color: string,
  count: int,
};
type bag = {
  color: string,
  contains: list(contain),
};
type bags = list(bag);

let getContains = stringArray => {
  stringArray->Array.reduce([], (acc, item) => {
    switch (item) {
    | "no other" => [{color: "no other", count: 0}]
    | _ =>
      let splited = item->Js.String2.split(" ");
      let count = splited->Array.getExn(0)->int_of_string;
      let color =
        splited->Array.getExn(1) ++ " " ++ splited->Array.getExn(2);
      let contain = {color, count};
      List.concat(acc, [contain]);
    }
  });
};

let parsed =
  input->List.map(line => {
    let splited = line->Js.String2.split(" contain ");
    let bag = splited->Array.getExn(0)->Js.String2.replace(" bags", "");
    let contains =
      splited
      ->Array.getExn(1)
      ->Js.String2.replaceByRe([%re "/bags?[.]/g"], "")
      ->Js.String2.trim
      ->Js.String2.splitByRe([%re "/ bags?[,] /g"])
      ->Array.keepMap(x => x)
      ->getContains;
    {color: bag, contains};
  });

let toUniqueSet = arr => {
  arr->Set.String.fromArray;
};

let rec traverse_up = color => {
  let res =
    parsed->List.reduce(
      [],
      (acc, bag) => {
        switch (bag.contains->List.getBy(contained_bag => contained_bag.color == color)) {
          | Some(_) =>
            let a = traverse_up(bag.color);
            List.concatMany([|acc, [bag.color], a|]);
          | None => acc
        };
      }
    );
    res;
};

let part1 =
  "shiny gold"
  ->traverse_up
  ->List.toArray
  ->toUniqueSet
  ->Set.String.size
  ->Js.log;

let rec traverse_down = color => {
  let res =
    parsed->List.reduce(
      0,
      (acc, bag) => {
        let items =
          bag.contains
          ->List.reduce(acc, (_acc, contained_bag) =>
              if (bag.color == color) {
                _acc
                + (
                  contained_bag.count
                  + contained_bag.count
                  * contained_bag.color->traverse_down
                );
              } else {
                _acc;
              }
            );
        items;
      },
    );
  res;
};

let part2 = "shiny gold"
->traverse_down
->Js.log;