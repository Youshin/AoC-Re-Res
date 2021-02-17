open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/input/day4.txt")->Js.String2.split("\n\n")

type raw_t = {
  byr: option<string>,
  iyr: option<string>,
  eyr: option<string>,
  hgt: option<string>,
  hcl: option<string>,
  ecl: option<string>,
  pid: option<string>,
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

let types = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "cid", "hgt"]

let range_match = (k:option<string>, min, max) => {
  let num = k->Belt.Option.getWithDefault("")->int_of_string;
  if min <= num && num <= max {
    num
  } else {
    0
  }
}

let regex_match = (k, regex) => {
  let word = k->Option.getWithDefault("")
  switch Js.String2.match_(word, regex) {
  | Some(match) =>
    if match->Array.getExn(0) == word {
      match->Array.getExn(0)
    } else {
      ""
    }
  | _ => ""
  }
}

let height_match = m => {
  let hgt = m->Option.getWithDefault("")->Js.String2.replaceByRe(%re("/(in|cm)/g"), "")->int_of_string
  let unit = m->Option.getWithDefault("")->Js.String2.replaceByRe(%re("/[0-9]+/"), "")
  if (hgt >= 150 && hgt <= 193 && unit == "cm") || (hgt >= 59 && hgt <= 76 && unit == "in") {
    {num: hgt, unit: unit}
  } else {
    {num: 0, unit: ""}
  }
}

let parseInput = input => {
  input->Js.Array2.map(l => {
    l
    ->Js.String2.replaceByRe(%re(`/\n/g`), " ")
    ->Js.String2.trim
    ->Js.String2.split(" ")
  })
}

let getAttribute = (data, attribute) => {
  switch data->Array.getBy((x) => x->Array.getExn(0) == attribute) {
    | Some(x) => x->Array.get(1);
    | _ => None
  }
}

let p1_check:array<string> => option<raw_t> = item => {
  let splited = item->Array.map(l => l->Js.String2.split(":"))
  let raw: raw_t = {
    byr: splited->getAttribute("byr"), iyr: splited->getAttribute("iyr"), eyr: splited->getAttribute("eyr"),
    hcl: splited->getAttribute("hcl"), ecl: splited->getAttribute("ecl"), hgt: splited->getAttribute("hgt"),
    pid: splited->getAttribute("pid"), cid: splited->getAttribute("cid")
  }
  if (
    raw.byr == None ||
    raw.iyr == None ||
    raw.eyr == None ||
    raw.hcl == None ||
    raw.ecl == None ||
    raw.hgt == None ||
    raw.pid == None
  ) {
    None;
  } else {
    Some(raw);
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
// let p1 = input->parseInput->Array.keepMap(l => l->p1_check)->Array.length->Js.log;

part1->Array.length->Js.log

let part2 = part1->Array.keepMap(x => x->p2_check)

part2->Array.length->Js.log
