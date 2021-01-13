open Belt

let input = Node.Fs.readFileAsUtf8Sync("./src/input/day2.txt")->Js.String2.split("\n")

let part1 = input->Array.reduce(0, (ans, _val) => {
  let line = _val->Js.String2.split(" ")
  // Js.log(line)

  let range = Array.map(line->Array.getExn(0)->Js.String2.split("-"), x => x->int_of_string)
  let key = line->Array.getExn(1)->Js.String2.charAt(0)

  let words = line->Array.getExn(2)
  // Js.log(range)
  // Js.log(key)
  // Js.log(words)
  // Js.String2.split(str, "") == String => string array
  // let input = Node.Fs.readFileAsUtf8Sync("day2.txt")->Js.String2.split("\n")->Belt.Array.map(i => {
  //   i->Js.String2.split(" ")
  // })

  let arr =
    Js.String2.castToArrayLike(words)
    ->Js.Array2.from
    // Js.log(arr)
    // ->{
    //   x->Js.log
    //   x
    // }

  let count = arr->Array.reduce(0, (count, _val) => {
    if key == _val {
      count + 1
    } else {
      count
    }
  })
  // Js.log(count)
  if count < range->Array.getExn(0) || count > range->Array.getExn(1) {
    ans
  } else {
    ans + 1
  }
  // words->String.length
})

Js.log(part1)
// 1. 한줄에 대해서 처리하는 함수로 추출하고, 리스트에 대해서 처리하도록 바꾸면 가독성이 올라갈 것 같음.
// 2. 카운트하는 로직과 Validation 하는 로직을 분리하기 : reduce로 한방에 하지 않고, (true/false) 또는 (Some/None)으로 처리하고 숫자세기

// part 2
// 함수형 프로그래밍
let part2 = input->Array.reduce(0, (ans, _val) => {
  let line = _val->Js.String2.split(" ")
  // Js.log(line)

  let range = Array.map(line->Array.getExn(0)->Js.String2.split("-"), x => x->int_of_string)
  let min = range->Array.getExn(0) - 1
  let max = range->Array.getExn(1) - 1
  let key = line->Array.getExn(1)->Js.String2.charAt(0)
//   let re = Js.Re.fromString(key);
  let words = line->Array.getExn(2)
  let arr = Js.Array2.fromMap(Js.String2.castToArrayLike(words), x => x)

  if arr->Js.Array2.unsafe_get(min) == arr->Js.Array2.unsafe_get(max) {
    ans
  } else if arr->Js.Array2.unsafe_get(min) != key && arr->Js.Array2.unsafe_get(max) != key {
    ans
  } else {
    ans + 1
  }
  
})
Js.log(part2)

  // words->String.length
  

//   switch (pred1, pred2) {
//   | (false, true)
//   | (true, false) => true
//   | _ => false
//   }
// })

// 3. Regex로 파싱 해보기 -> https://www.notion.so/greenlabs/4374146fc1ad4d68bdc2474607583607#9d51c84ca7054f75a426a9f966354c8a
 
// 4. input->map(parse)->map(isValid)->filter(true)->count() 구조로 리팩토링하면
// p1, p2 문제에서 isValid 함수만 바꾸면 되고, 중복 코드가 줄어들 것 같다.

// 5. 타입의 어레이로 만들자!!! -> 가장 심플하게는 Tuple로 하면 된다. (a, b, c, d)
// 6. Belt.Array를 주로 쓰자

// 7. ["1-3 a: abcde", ...] -- f --> [(1, 3, "a", "abcde"), ...] -- g --> [true, false, true....] -- h --> [true, true, true, ...] -- length --> 정답!

// type password_t = {
//   min: int,
//   max: int,
//   char: string,
//   password: string,
// }



// pattern matching
