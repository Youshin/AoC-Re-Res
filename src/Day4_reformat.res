open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/input/day4.txt")->Js.String2.split("\n\n")

type raw_t = {
  byr: string,
  iyr: string,
  eyr: string,
  hgt: string,
  hcl: string,
  ecl: string,
  pid: string,
  cid: option<string>,
}

type hgt_t = {
  num: int,
  unit: string,
}

type passport_t = {
  byr: int,
  iyr: int,
  eyr: int,
  hgt: hgt_t,
  hcl: string,
  ecl: string,
  pid: string,
  cid: option<string>,
}

let init_raw: raw_t = {
  byr: "",
  iyr: "",
  eyr: "",
  hgt: "",
  hcl: "",
  ecl: "",
  pid: "",
  cid: None,
}

let init_passport: passport_t = {
  byr: 0,
  iyr: 0,
  eyr: 0,
  hgt: {num: 0, unit: ""},
  hcl: "",
  ecl: "",
  pid: "",
  cid: None,
}

let types = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "cid", "hgt"]

let range_match = (k, min, max) => {
  if min <= k->int_of_string && k->int_of_string <= max {
    k->int_of_string
  } else {
    0
  }
}

let regex_match = (k, regex) => {
  switch Js.String2.match_(k, regex) {
  | Some(match) =>
    if match->Array.getExn(0) == k {
      match->Array.getExn(0)
    } else {
      ""
    }
  | _ => ""
  }
}

let height_match = m => {
  let num = m->Js.String2.replaceByRe(%re("/(in|cm)/g"), "")
  let unit = m->Js.String2.replaceByRe(%re("/[0-9]+/"), "")
  let hgt = num->int_of_string
  if (hgt >= 150 && hgt <= 193 && unit == "cm") || (hgt >= 59 && hgt <= 76 && unit == "in") {
    {num: hgt, unit: unit}
  } else {
    {num: 0, unit: ""}
  }
}

let parseInput = input => {
  input->Js.Array2.map(l => {
    let raw = l
    ->Js.String2.replaceByRe(%re(`/\n/g`), " ")
    ->Js.String2.trim
    ->Js.String2.split(" ")
    ->Js.Array2.map(l => {
      let set = l->Js.String2.split(":")
      (set->Array.getExn(0), set->Array.getExn(1))
    })
    ->Array.reduce(init_raw, (acc, item) => {
      switch item {
      | ("byr", x) => {...acc, byr: x}
      | ("iyr", x) => {...acc, iyr: x}
      | ("eyr", x) => {...acc, eyr: x}
      | ("hgt", x) => {...acc, hgt: x}
      | ("hcl", x) => {...acc, hcl: x}
      | ("ecl", x) => {...acc, ecl: x}
      | ("pid", x) => {...acc, pid: x}
      | ("cid", x) => {...acc, cid: Some(x)}
      | _ => init_raw
      }
    })
    raw
  })
}

// let raw_check = (item: raw_t) => {
//   if (
//     item.byr == "" ||
//     item.iyr == "" ||
//     item.eyr == "" ||
//     item.hcl == "" ||
//     item.ecl == "" ||
//     item.hgt == "" ||
//     item.pid == ""
//   ) {
//     false
//   } else {
//     true
//   }
// }

// let passport_check = (item: passport) => {
//   if (
//     item.byr == 0 ||
//     item.iyr == 0 ||
//     item.eyr == 0 ||
//     item.hcl == "" ||
//     item.ecl == "" ||
//     item.hgt == {num: 0, unit: ""} ||
//     item.pid == ""
//   ) {
//     false
//   } else {
//     true
//   }
// }

// PassportEntry | Passport
// raw | password



// let p1_check: string => option<raw_t>
// keepMap
// let p2_check: raw_t => option<passport_t>
// keepMap
// length

let p1_check:raw_t => option<raw_t> = item => {
  if (
    item.byr == "" ||
    item.iyr == "" ||
    item.eyr == "" ||
    item.hcl == "" ||
    item.ecl == "" ||
    item.hgt == "" ||
    item.pid == ""
  ) {
    None;
  } else {
    Some(item);
  }
}

let p2_check:raw_t => option<passport_t> = item => {
  try {
    let validated = {
      byr: item.byr->range_match(1920, 2002),
      iyr: item.iyr->range_match(2010, 2020),
      eyr: item.eyr->range_match(2020, 2030),
      hcl: item.hcl->regex_match(%re("/(#)[a-f0-9]{6}/")),
      ecl: item.ecl->regex_match(%re("/(amb|blu|brn|gry|grn|hzl|oth)/")),
      pid: item.pid->regex_match(%re("/\d{9}/")),
      hgt: item.hgt->height_match,
      cid: item.cid,
    };
    if (validated.byr == 0 ||
      validated.iyr == 0 ||
      validated.eyr == 0 ||
      validated.hgt == {num:0, unit:""} ||
      validated.hcl == "" ||
      validated.ecl == "" ||
      validated.pid == "") {
        None
    } else {
      Some(validated);
    }
  } catch {
  | _ => None
  }
}

let part1 = input->parseInput->Array.keepMap(x=> x->p1_check)

part1->Array.length->Js.log

let part2 = part1->Array.keepMap(x => x->p2_check)

part2->Array.length->Js.log
