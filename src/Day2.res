open Belt

let input = Node.Fs.readFileAsUtf8Sync("./src/input/day2.txt")->Js.String2.split("\n")

let part1 = input->Array.reduce(0, (ans, _val) => {
    let line = _val->Js.String2.split(" ");
    // Js.log(line)

    let range = Array.map(line->Array.getExn(0)->Js.String2.split("-"), x => x->int_of_string)
    let key = line->Array.getExn(1)->Js.String2.charAt(0)

    let words = line->Array.getExn(2)
    // Js.log(range)
    // Js.log(key)
    // Js.log(words)

    let arr = Js.Array2.fromMap(Js.String2.castToArrayLike(words), x => x)
    // Js.log(arr) 

    let count = arr->Array.reduce(0, (count, _val) => {
        switch _val {
            | word => { 
                if(key == word) {
                    count + 1
                }else {
                    count
                }
            }
            | _ => {
                count
            }
        }
    },);
    // Js.log(count)
    if (count < range->Array.getExn(0) || count > range->Array.getExn(1) ) {
        ans
    }else {
        ans + 1
    }
    // words->String.length
    },
);

Js.log(part1)

// part 2

let part2 = input->Array.reduce(0, (ans, _val) => {
    let line = _val->Js.String2.split(" ");
    // Js.log(line)

    let range = Array.map(line->Array.getExn(0)->Js.String2.split("-"), x => x->int_of_string)
    let min = range->Array.getExn(0)-1
    let max = range->Array.getExn(1)-1
    let key = line->Array.getExn(1)->Js.String2.charAt(0)

    let words = line->Array.getExn(2)
    let arr = Js.Array2.fromMap(Js.String2.castToArrayLike(words), x => x)
    
    if (arr->Js.Array2.unsafe_get(min) == arr->Js.Array2.unsafe_get(max)) {
        
        ans
    }else if(arr->Js.Array2.unsafe_get(min) != key && arr->Js.Array2.unsafe_get(max) != key) {
        
        ans
    }else {
        ans + 1
    }
    // words->String.length
    },
);

Js.log(part2)