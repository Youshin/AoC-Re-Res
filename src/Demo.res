// open Belt
// let target = 2020

// let input = Node.Fs.readFileAsUtf8Sync("./src/input/day1_sample.txt")->Js.String2.split("\n")
//   ->Array.map(_val => _val->int_of_string)
//   ->Array.reduce(Js.Dict.empty(), (arr, _val) => {
//         arr->Js.Dict.set(_val->string_of_int, _val);
//         arr;
//       },
//     );

// let keys = input->Js.Dict.keys->Js.Array2.map(a=>a->int_of_string)

// Js.log(keys)

// Js.Array2.reduce(keys, (acc, item) => {
//         let a = keys->Js.Array2.reduce((accc, item) => 
//         {
//             Js.log("accc: "++accc->string_of_int)
//             Js.log("item: "++item->string_of_int)
//             accc + item
//         }, acc);
//         Js.log("acc: "++acc->string_of_int)
//         Js.log("item: "++item->string_of_int)
//         Js.log("a: "++a->string_of_int)
//         a
//     }, 0)

// // let res2 = {
// //   for i in 0 to length-1 {
// //     for j in 1 to length {
// //       let v1 = keys->Array.get(i)
// //       let v2 = keys->Array.get(j)
// //       switch(v1, v2) {
// //         | (Some(v1), Some(v2)) => {
// //           if v1 + v2 <= 2020 {
// //             let v = 2020 - v1 - v2
// //             if keys->Js.Array2.includes(v) {
// //               Js.log(v1 * v2 * v)
// //             }
// //           }
// //         }
// //         | _ => ()
// //       }
// //     }
// //   }
// // }
