// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Js_dict = require("bs-platform/lib/js/js_dict.js");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var Caml_format = require("bs-platform/lib/js/caml_format.js");

var input = Belt_Array.reduce(Belt_Array.map(Fs.readFileSync("./input/input_sample.txt", "utf8").split("\n"), Caml_format.caml_int_of_string), {}, (function (arr, _val) {
        arr[String(_val)] = _val;
        return arr;
      }));

var keys = Object.keys(input).map(Caml_format.caml_int_of_string);

var part1 = keys.filter(function (key) {
      return Js_dict.get(input, String(2020 - key | 0)) !== undefined;
    });

console.log(Belt_Array.reduce(part1, 1, (function (a, b) {
            return Math.imul(a, b);
          })));

var target = 2020;

exports.input = input;
exports.target = target;
exports.keys = keys;
exports.part1 = part1;
/* input Not a pure module */
