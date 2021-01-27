// open Belt;
// let input =
//   Node.Fs.readFileAsUtf8Sync("./src/input/day7.txt")
//   ->Js.String2.split("\n")
//   ->List.fromArray


// type contain = {
//     color: string,
//     count: int
// };
// type bag = {
//     color: string,
//     contains: list(contain)
// };
// type bags = list(bag);


// // input->Js.log

// let getContains = (stringArray) => {
//     stringArray->Array.reduce([], (acc, item) => {
//         switch item {
//         | "no other" => {[
//             {
//                 color: "no other",
//                 count: 0
//             }];
//             // ["no other"]
//         }
//         | _ => {
//             let splited = item->Js.String2.split(" ");
//             let count = splited->Array.getExn(0)->int_of_string;
//             let color = splited->Array.getExn(1) ++ " " ++ splited->Array.getExn(2);
//             let contain = {
//                 color: color,
//                 count: count
//             };
//             List.concat(acc, [ contain ]) 
//             }
//         };
//     })
    
// }

// let parsed = input->List.map(line => {
//         let splited = line->Js.String2.split(" contain ");
//         let bag = splited->Array.getExn(0)->Js.String2.replace(" bags","");
//         let contains = splited->Array.getExn(1)
//             ->Js.String2.replaceByRe([%re "/bags?[.]/g"],"")
//             ->Js.String2.trim
//             ->Js.String2.splitByRe([%re "/ bags?[,] /g"])
//             ->Array.keepMap(x=>x)
//             ->getContains;
//         {
//             color: bag,
//             contains: contains
//         };

//     })

// let toUniqueSet = arr =>
//   arr->List.toArray->Set.String.fromArray


// let rec traverse = (color) => {
//     let res = parsed->List.reduce([], (acc, item) => {
//         // item->Js.log
//         // acc->Js.log
//         let arr = item.contains->List.reduce(acc, (a, i) => {
//             // i->Js.log
//             if(i.color == color) {
//                 [item.color, ...traverse(item.color)];
//             } else {
//                 a
//             }
//         });
        
//         // {^오^} 화이팅
//         // arr->Js.log
//         acc->Js.log;
//         arr->Js.log;
//         [acc, ...arr]
//         Array.concat(acc,arr)->toUniqueSet->Set.String.toList
//     });
//     res
// }
// traverse("shiny gold")->Array.length->Js.log
// // let 
// // parse->Js.log

// // let b = (parse) => {
// //     parse->List.reduce(0, (a,i) => {
// //         a+i.contains->List.reduce(0, (acc,item) => {
// //             if (item.color == "shiny gold") {
// //                 acc + item.count
// //             }else if(item.color == "no other") {
// //                 acc
// //             }else {
// //                 a
// //             }
// //         });
// //     })
// // }

// // b->Js.log