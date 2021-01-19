open Belt
let input = Node.Fs.readFileAsUtf8Sync("./src/input/day4.txt")->Js.String2.split("\n\n")

// 튜플로 해보기?

// type raw_t = {
//     byr: string,
//     iyr: string,
//     eyr: string,
//     hgt: string,
//     hcl: string,
//     ecl: string,
//     pid: string,
//     cid: string
// };

// raw_t -> passport_t -> parse

// type passport_t = {
//     byr: int,
//     iyr: int,
//     eyr: int,
//     hgt: string,
//     hcl: string,
//     ecl: string,
//     pid: int,
//     cid: option(int)
// };

// let validator = passport => {
//     let length = passport->Array.length
//     let isFull = length === 8
//         passport->Js.log
//     if isFull {
//         true
//     } else if length === 7 {
//         let a = passport->Array.some(field => field->Array.getExn(0) === "cid")
//         !a
//     } else {
//         false
//     }
// }

let range_match = (k, min, max, m) => {
  switch m->Js.Dict.get(k) {
  | Some(_val) => {
      let num = _val->int_of_string
      let res = min <= num && num <= max
      res
    }
  | None => false
  }
}

// let regex_match = (k, regex, m) => 
//     m->Js.Dict.get(k) 
//     ->Option.map(v => v->Js.String2.match_(regex)->Array.getExn(0) == v)
    
//Belt map module=~id
let regex_match = (k, regex, m) => {
  switch m->Js.Dict.get(k) {
  | Some(_val) =>
    switch Js.String2.match_(_val, regex) {
    | Some(match) => _val == match->Array.getExn(0)
    | None => false
    }
  | None => false
  }
}

let height_match = (m) => {
    switch m->Js.Dict.get("hgt") {
        | Some(_val) => {
            // _val->Js.log
            let num = _val->Js.String2.replaceByRe(%re("/(in|cm)/g"), "")
            let unit = _val->Js.String2.replaceByRe(%re("/[0-9]+/"), "")
            let hgt = num->int_of_string
            // num->Js.log
            // hgt->Js.log
            // unit->Js.log
            let res = (hgt >= 150 && hgt <= 193 && unit == "cm") || (hgt >= 59 && hgt <= 76 && unit=="in")
            res
        }
        | None => false
    }
}

// byr (Birth Year) - four digits; at least 1920 and at most 2002.
// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
// hgt (Height) - a number followed by either cm or in:
// If cm, the number must be at least 150 and at most 193.
// If in, the number must be at least 59 and at most 76.
// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
// pid (Passport ID) - a nine-digit number, including leading zeroes.


let parseInput = () => {
    input->Js.Array2.map(l => {
        l->Js.String2.replaceByRe(%re(`/\n/g`), " ")
        ->Js.String2.trim
        ->Js.String2.split(" ")
        ->Js.Array2.map(l => {
            let set = l->Js.String2.split(":")
            (set->Array.getExn(0), set->Array.getExn(1))
        })->Js.Dict.fromArray
    })
}

// ["a", "b", "c"] -> (a, b, c, d...)
// let [a, b] = ["a", "b"] -> [{"a": "a", "b": "b"}] -> [{"a":"b"}]
// {"a": a
//  "b": b}
let part1 = parseInput()
let ans = part1
->Array.keep(x => 
    switch x->Js.Dict.entries->Array.length {
        | 8 => true
        | 7 => {
            x->Js.Dict.get("cid") == None
        }
        | _ => false
    }
)
->Array.length

ans
->Js.log

let part2 = parseInput()

let ans2 = part2
->Array.keep(x => range_match("byr", 1920, 2002, x))
->Array.keep(x => range_match("iyr", 2010, 2020, x))
->Array.keep(x => range_match("eyr", 2020, 2030, x))
->Array.keep(x => regex_match("hcl", %re("/(#)[a-f0-9]{6}/"), x))
->Array.keep(x => regex_match("ecl", %re("/(amb|blu|brn|gry|grn|hzl|oth)/"), x))
->Array.keep(x => regex_match("pid", %re("/[0-9]{9}/"),x))
->Array.keep(x => x->height_match)
->Array.length

ans2
->Js.log


// a->Array.map(validator)->Array.keep(v => v)->Array.length->Js.log

