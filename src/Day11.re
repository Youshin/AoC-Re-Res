open Belt;
type status = EMPTY | OCCUPIED | FLOOR | NONE;

type matrix_idx = {
    row: int,
    col: int
}

let check_idx = [|{row: 0, col: 1}, {row: 0, col: -1}, {row: 1, col: 0}, {row:  -1, col: 0},
    {row:  1, col:  1},{row: 1, col: -1},{row: -1, col: 1},{row: -1, col: -1} |];

module type part = {
    let checkChangeStatus: (status, int) => bool;
    let countOccupied: (array(array(status))) => int;
    let fillSeats: (array(array(status))) => (array(array(status)));
};

module FillSeats = (Part: part) => {
    let input =
        Node.Fs.readFileAsUtf8Sync("./src/input/day11.txt")
        ->Js.String2.split("\n")
        ->Array.map(x => 
            x->Js.String2.split("")
            ->Array.map(char => switch(char) {
                | "L" => EMPTY
                | "#" => OCCUPIED
                | "." => FLOOR
                | _ => NONE
            }));
    let solve = () => {
        input->Part.fillSeats->Part.countOccupied->Js.log;
    }
};

module Part1 = {
    let checkChangeStatus = (status, count) => {
        switch(status) {
            | OCCUPIED when count >= 4 => true
            | EMPTY when count == 0 => true
            | _ => false
        }
    }
    let countOccupied = matrix => {
        matrix->Array.reduce(0, (acc,item) => {
            item->Array.keep(x=> x == OCCUPIED)->Array.length + acc;
        })
    };
    let lookAround = (data, row_idx, col_idx, status) => {
        let check = [|{row: row_idx, col: col_idx + 1}, {row: row_idx, col: col_idx - 1}, {row: row_idx + 1, col: col_idx}, {row: row_idx - 1, col: col_idx},
        {row: row_idx + 1, col: col_idx + 1},{row: row_idx + 1, col: col_idx - 1},{row: row_idx - 1, col: col_idx + 1},{row: row_idx - 1, col: col_idx - 1} |];

        let count = check->Array.reduce(0, (acc, item) => {
            switch(data->Array.get(item.row)) {
            | Some(row) => {
                switch(row->Array.get(item.col)) {
                | Some(OCCUPIED) => acc + 1
                | _ => acc
                }
            }
            | _ => acc
            }
        });
        checkChangeStatus(status, count);
    }
    let rec fillSeats = (data) => {
        let matrix = data->Array.mapWithIndex( (i, element_row) => {
            let new_row = element_row->Array.reduceWithIndex([||], (cols, element_col, j) => {
                switch(element_col) {
                    | EMPTY => {
                        if(lookAround(data,i,j,EMPTY)) {
                            cols->Array.concat([|OCCUPIED|]);
                        }else {
                            cols->Array.concat([|EMPTY|]);
                        }
                    }
                    | OCCUPIED => {
                        if(lookAround(data, i, j, OCCUPIED)) {
                            cols->Array.concat([|EMPTY|]);
                        }else {
                            cols->Array.concat([|OCCUPIED|]);
                        }
                    }
                    | FLOOR => cols->Array.concat([|FLOOR|])
                    | _ => cols->Array.concat([|NONE|])
                }
            });
            new_row;
        });
        
        let remain = matrix->Array.mapWithIndex((i, x) => {
            Array.cmp(x, data->Array.getExn(i), (a,b) => compare(a,b));
        })->Array.keep(x => x != 0);



        if (remain->Array.length == 0) {
            matrix; // base case
        }else {
            fillSeats(matrix); // 
        }
    }
}

module Part2 = {
    let checkChangeStatus = (status, count) => {
        switch(status) {
            | OCCUPIED when count >= 5 => true
            | EMPTY when count == 0 => true
            | _ => false
        }
    };
    let countOccupied = matrix => {
        matrix->Array.reduce(0, (acc,item) => {
            item->Array.keep(x=> x == OCCUPIED)->Array.length + acc;
        })
    };
    let rec lookDeeper = (data, row_idx, col_idx, check_idx) => {
        let count = check_idx->Array.reduce(0, (acc, item) => {
            let check = {row: row_idx + item.row, col: col_idx + item.col}
            switch(data->Array.get(check.row)) {
                | Some(row) => {
                    switch(row->Array.get(check.col)) {
                    | Some(FLOOR) => { 
                        acc + lookDeeper(data, check.row, check.col, [|item|]);
                    }
                    | Some(OCCUPIED) => {
                        acc + 1
                    }
                    | Some(_) => {
                        acc
                    }
                    | None => acc
                    }
                }
                | _ => acc
            }
        });
        count;
    }
    let rec fillSeats = (data) => {
        let matrix = data->Array.mapWithIndex( (i, element_row) => {
            let new_row = element_row->Array.reduceWithIndex([||], (cols, element_col, j) => {
                switch(element_col) {
                    | EMPTY => {
                        if(checkChangeStatus(EMPTY, lookDeeper(data, i,j, check_idx))) {
                            cols->Array.concat([|OCCUPIED|]);
                        }else {
                            cols->Array.concat([|EMPTY|]);
                        }
                    }
                    | OCCUPIED => {
                        if(checkChangeStatus(OCCUPIED, lookDeeper(data, i,j, check_idx))) {
                            cols->Array.concat([|EMPTY|]);
                        }else {
                            cols->Array.concat([|OCCUPIED|]);
                        }
                    }
                    | FLOOR => cols->Array.concat([|FLOOR|])
                    | _ => cols->Array.concat([|NONE|])
                }
            });
            new_row;
        });
    
        // matrix
        let remain = matrix->Array.mapWithIndex((i, x) => {
            Array.cmp(x, data->Array.getExn(i), (a,b) => compare(a,b));
        })->Array.keep(x => x != 0);

        if (remain->Array.length == 0) {
            matrix; // base case
        }else {
            fillSeats(matrix); // 
        }
    };
}

module Answer1 = FillSeats(Part1);
Answer1.solve();
module Answer2 = FillSeats(Part2);
Answer2.solve();






// let checkChangeStatus = (status, count) => {
//     switch(status) {
//         | OCCUPIED when count >= 4 => true
//         | EMPTY when count == 0 => true
//         | _ => false
//     }
// }

// let lookAround = (data, row_idx, col_idx, status) => {
//     let check = [|{row: row_idx, col: col_idx + 1}, {row: row_idx, col: col_idx - 1}, {row: row_idx + 1, col: col_idx}, {row: row_idx - 1, col: col_idx},
//     {row: row_idx + 1, col: col_idx + 1},{row: row_idx + 1, col: col_idx - 1},{row: row_idx - 1, col: col_idx + 1},{row: row_idx - 1, col: col_idx - 1} |];

//     let count = check->Array.reduce(0, (acc, item) => {
//         switch(data->Array.get(item.row)) {
//             | Some(row) => {
//                 switch(row->Array.get(item.col)) {
//                 | Some(OCCUPIED) => { 
//                     acc + 1
//                 }
//                 | _ => acc
//                 }
//             }
//             | _ => acc
//         }
//     });
//     checkChangeStatus(status, count);
// }

// let checkChangeStatus_p2 = (status, count) => {
//     switch(status) {
//         | OCCUPIED when count >= 5 => true
//         | EMPTY when count == 0 => true
//         | _ => false
//     }
// }
// let rec lookDeeper = (data, row_idx, col_idx, check_idx) => {
//     let count = check_idx->Array.reduce(0, (acc, item) => {
//         let check = {row: row_idx + item.row, col: col_idx + item.col}
//         switch(data->Array.get(check.row)) {
//             | Some(row) => {
//                 switch(row->Array.get(check.col)) {
//                 | Some(FLOOR) => { 
//                     acc + lookDeeper(data, check.row, check.col, [|item|]);
//                 }
//                 | Some(OCCUPIED) => {
//                     acc + 1
//                 }
//                 | Some(_) => {
//                     acc
//                 }
//                 | None => acc
//                 }
//             }
//             | _ => acc
//         }
//     });
//     count;
// }

// let rec fillSeats = (data) => {
//     let matrix = data->Array.mapWithIndex( (i, element_row) => {
//         let new_row = element_row->Array.reduceWithIndex([||], (cols, element_col, j) => {
//             switch(element_col) {
//                 | EMPTY => {
//                     if(lookAround(data,i,j,EMPTY)) {
//                         cols->Array.concat([|OCCUPIED|]);
//                     }else {
//                         cols->Array.concat([|EMPTY|]);
//                     }
//                 }
//                 | OCCUPIED => {
//                     if(lookAround(data, i, j, OCCUPIED)) {
//                         cols->Array.concat([|EMPTY|]);
//                     }else {
//                         cols->Array.concat([|OCCUPIED|]);
//                     }
//                 }
//                 | FLOOR => cols->Array.concat([|FLOOR|])
//                 | _ => cols->Array.concat([|NONE|])
//             }
//         });
//         new_row;
//     });
    
//     let remain = matrix->Array.mapWithIndex((i, x) => {
//         Array.cmp(x, data->Array.getExn(i), (a,b) => compare(a,b));
//     })->Array.keep(x => x != 0);



//     if (remain->Array.length == 0) {
//         matrix; // base case
//     }else {
//         fillSeats(matrix); // 
//     }
// }


// // let part1 = input->fillSeats->Array.reduce(0, (acc,item) => {
// //     item->Array.keep(x=> x == OCCUPIED)->Array.length + acc;
// // });
// // part1->Js.log;



// let rec fillSeats_p2 = (data) => {
//     let matrix = data->Array.mapWithIndex( (i, element_row) => {
//         let new_row = element_row->Array.reduceWithIndex([||], (cols, element_col, j) => {
//             switch(element_col) {
//                 | EMPTY => {
//                     if(checkChangeStatus_p2(EMPTY, lookDeeper(data, i,j, check_idx))) {
//                         cols->Array.concat([|OCCUPIED|]);
//                     }else {
//                         cols->Array.concat([|EMPTY|]);
//                     }
//                 }
//                 | OCCUPIED => {
//                     if(checkChangeStatus_p2(OCCUPIED, lookDeeper(data, i,j, check_idx))) {
//                         cols->Array.concat([|EMPTY|]);
//                     }else {
//                         cols->Array.concat([|OCCUPIED|]);
//                     }
//                 }
//                 | FLOOR => cols->Array.concat([|FLOOR|])
//                 | _ => cols->Array.concat([|NONE|])
//             }
//         });
//         new_row;
//     });
    
//     // matrix
//     let remain = matrix->Array.mapWithIndex((i, x) => {
//         Array.cmp(x, data->Array.getExn(i), (a,b) => compare(a,b));
//     })->Array.keep(x => x != 0);

//     if (remain->Array.length == 0) {
//         matrix; // base case
//     }else {
//         fillSeats_p2(matrix); // 
//     }
// }

// let part2 = input->fillSeats_p2->Array.reduce(0, (acc,item) => {
//     item->Array.keep(x=> x == OCCUPIED)->Array.length + acc;
// })->Js.log