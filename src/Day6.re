open Belt;
let input =
  Node.Fs.readFileAsUtf8Sync("./src/input/day6.txt")
  ->Js.String2.split("\n\n");
let merge = input => {
  input->Js.Array2.map(l => {
    l->Js.String2.split("")->Array.keep(x => x != "\n")
  });
};

let merged_input = input->merge;

let toUniqueSet = arr =>
  arr->Array.reduce(Set.String.empty, (acc, item) =>
    Set.String.union(acc, item->Set.String.fromArray)
  );

let countMatchedItem = (a, b) => {
  a->Set.String.intersect(b)->Set.String.toArray->Array.length;
};

let part1 =
  merged_input->Array.reduce(
    0,
    (acc, item) => {
      let countMatches =
        merged_input
        ->toUniqueSet
        ->countMatchedItem(item->Set.String.fromArray);
      countMatches + acc;
    },
  );

part1->Js.log;

let matchEveryOne = wordsArr => {
  wordsArr
  ->Array.reduce(merged_input->toUniqueSet, (acc, item) => {
      acc->Set.String.intersect(item->Set.String.fromArray)
    })
  ->Set.String.toArray
  ->Array.length;
};

let parseInput = input => {
  input
  ->Js.String2.split("\n")
  ->Js.Array2.map(input => {input->Js.String2.split("")});
};

let part2 =
  input
  ->Js.Array2.map(l => {l->parseInput->matchEveryOne})
  ->Array.reduce(0, (acc, item) => acc + item);

part2->Js.log;
