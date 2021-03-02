open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/input/day4.txt")->Js.String2.split("\n\n")

// p1: string -> passport_entry

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

let range_match = (k: option<string>, min, max) => {
  switch k {
  | Some(x) => min <= x->int_of_string && x->int_of_string <= max ? Some(x->int_of_string) : None
  | None => None
  }
}

let regex_match = (k, regex) => {
  switch k {
  | Some(x) =>
    switch Js.String2.match_(x, regex) {
    | Some(match) when match->Array.getExn(0) == x => match->Array.get(0)
    | _ => None
    }
  | None => None
  }
}

let height_match = m => {
  switch m {
  | Some(x) => {
      let hgt = x->Js.String2.replaceByRe(%re("/(in|cm)/g"), "")->int_of_string
      let unit = x->Js.String2.replaceByRe(%re("/[0-9]+/"), "")
      if (hgt >= 150 && hgt <= 193 && unit == "cm") || (hgt >= 59 && hgt <= 76 && unit == "in") {
        Some({num: hgt, unit: unit})
      } else {
        None
      }
    }
  | None => None
  }
}

let parseInput = input => {
  input->Js.Array2.map(l => {
    l->Js.String2.replaceByRe(%re(`/\n/g`), " ")->Js.String2.trim
  })
}

let getAttribute = (data, attribute) => {
  switch data->Array.getBy(x => x->Array.getExn(0) == attribute) {
  | Some(x) => x->Array.getExn(1)
  | _ => None
  }
}

let mapping_dict_to_type = dict => {
  byr: dict->Js.Dict.get("byr"),
  iyr: dict->Js.Dict.get("iyr"),
  eyr: dict->Js.Dict.get("eyr"),
  hcl: dict->Js.Dict.get("hcl"),
  ecl: dict->Js.Dict.get("ecl"),
  hgt: dict->Js.Dict.get("hgt"),
  pid: dict->Js.Dict.get("pid"),
  cid: dict->Js.Dict.get("cid"),
}

let p1_check: string => option<raw_t> = item => {
  let splited = item
  ->Js.String2.split(" ")
  ->Array.map(l => {
    let set = l->Js.String2.split(":")
    (set->Array.getExn(0), set->Array.getExn(1))
  })
  ->Js.Dict.fromArray
  switch splited->Js.Dict.entries->Array.length {
  | 8 => Some(mapping_dict_to_type(splited))
  | 7 when splited->Js.Dict.get("cid") == None => Some(mapping_dict_to_type(splited))
  | _ => None
  }
}

type passport_t = {
  byr: option<int>,
  iyr: option<int>,
  eyr: option<int>,
  hgt: option<hgt_t>,
  hcl: option<string>,
  ecl: option<string>,
  pid: option<string>,
  cid: option<string>,
}

let isPassport = passport =>
  (passport.byr == None ||
  passport.iyr == None ||
  passport.eyr == None ||
  passport.hgt == None ||
  passport.hcl == None ||
  passport.ecl == None ||
  passport.pid == None) == false

let p2_check: raw_t => option<passport_t> = item => {
  let passport = {
    byr: item.byr->range_match(1920, 2002),
    iyr: item.iyr->range_match(2010, 2020),
    eyr: item.eyr->range_match(2020, 2030),
    hcl: item.hcl->regex_match(%re("/(#)[a-f0-9]{6}/")),
    ecl: item.ecl->regex_match(%re("/(amb|blu|brn|gry|grn|hzl|oth)/")),
    pid: item.pid->regex_match(%re("/^[0-9]{9}$/")),
    hgt: item.hgt->height_match,
    cid: item.cid,
  }
  if passport->isPassport {
    Some(passport)
  } else {
    None
  }
}

let part1 = input->parseInput->Array.keepMap(x => x->p1_check)
part1->Array.length->Js.log

let part2 = part1->Array.keepMap(x => x->p2_check)
part2->Array.length->Js.log
