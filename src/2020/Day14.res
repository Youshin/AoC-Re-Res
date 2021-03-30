// open Belt
// let input = Node.Fs.readFileAsUtf8Sync("./src/input/day14_sample.txt")

// type mem = {
//   location: int,
//   value: int,
// }

// type data = {
//   mask: string,
//   mems: array<mem>,
// }
// let split = lines => {
//   lines->Js.String2.split("\nmask")->Array.map(x => x->Js.String2.split("\nmem"))
// }
// // input->split->Js.log
// let parse = data => {
//   let mask = switch data->Array.get(0) {
//   | Some(x) => x->Js.String2.split(" = ")->Array.get(1)
//   | None => None
//   }
//   let mems =
//     data
//     ->Array.keepWithIndex((_, idx) => idx != 0)
//     ->Array.map(x => {
//       let re = %re("/[0-9]+/")
//       let memloc = switch x |> Js.Re.exec_(re) {
//       | Some(s) =>
//         switch Js.Re.matches(s)->Array.get(0) {
//         | Some(num) => num->Int.fromString
//         | None => None
//         }
//       | None => None
//       }
//       let memval = switch x->Js.String2.split(" = ")->Array.get(1) {
//       | Some(num) => num->Int.fromString
//       | None => None
//       }

//       {location: memloc->Option.getExn, value: memval->Option.getExn}
//     })
//   {mask: mask->Option.getExn, mems: mems}
// }

// let parsed = input->split->Array.map(x => x->parse)

// // Js.Int.toStringWithRadix(11, ~radix=2)->Js.log

// let masking = (mask, mem) => {
//   let memval = Js.Int.toStringWithRadix(mem.value, ~radix=2)->Js.String2.split("")
//   let memloc = mem.location
//   let maskArr = mask->Js.String2.split("")
//   // memloc->Js.log
//   // memval->Js.log
//   // maskArr->Js.log

//   let reversed_mask = maskArr->Array.reduce("", (acc, item) => item ++ acc)->Js.String2.split("")
//   let reversed_memval = memval->Array.reduce("", (acc, item) => item ++ acc)->Js.String2.split("")

//   let masked = reversed_memval->Array.reduceWithIndex("", (acc, item, idx) => {
//     switch reversed_mask->Array.get(idx) {
//     | Some("X") => acc ++ item
//     | Some(num) => acc ++ num
//     | None => raise(Not_found)
//     }
//   })

//   let masked_len = masked->Js.String2.length
//   (
//     memloc,
//     (mask->Js.String2.substring(~from=0, ~to_=36 - masked_len) ++ masked)
//       ->Js.String2.replace("X", "0"),
//   )
// }

// let maskResolver = maskedData => {
//   maskedData
//   ->Js.String2.split("")
//   ->Array.reduce("", (acc, item) => {
//     switch item {
//     | "X" => acc ++ "0"
//     | _ => acc ++ item
//     }
//   })
// }

// let masked = parsed->Array.map(x => {
//   x.mems->Array.map(item => {
//     masking(x.mask, item)
//   })
// })

// let resolved = masked->Array.map(x => {
//   x->Array.map(b => {
//     let (loc, mask) = b
//     (loc, mask->maskResolver)
//   })
// })

// // resolved->Js.log
// // let _val = 000000000000000000000000000001001001

// // let binaryVal =
// // Js.Int.toStringWithRadix(binaryVal, ~radix=10)->Js.log

