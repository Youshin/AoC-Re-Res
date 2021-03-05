open Belt

module Action = {
    type t =
        | N(int)
        | S(int)
        | E(int)
        | W(int)
        | L(int)
        | R(int)
        | F(int);

    let getDistance = (t) => {
        switch(t) {
            | N(v) => v
            | S(v) => v
            | E(v) => v
            | W(v) => v
            | L(v) => v
            | R(v) => v
            | F(v) => v
        }
    }
};

type direction = 
    | North
    | East
    | South
    | West;

type point = {
    x: int,
    y: int
};
type ship = {
    facing: direction,
    location: point
};

let getDistance = (location: point) => abs(location.x) + abs(location.y);

let input =
Node.Fs.readFileAsUtf8Sync("./src/input/day12.txt")
->Js.String2.split("\n")->List.fromArray;

let parse = (input) => input->List.map(l => {
    let splited = [|l->Js.String2.get(0), l->Js.String2.sliceToEnd(~from=1)|]->List.fromArray;
    let num = splited->List.getExn(1)->int_of_string;
    switch (splited->List.get(0)) {
        | Some("N") => Action.N(num);
        | Some("S") => Action.S(num);
        | Some("E") => Action.E(num);
        | Some("W") => Action.W(num);
        | Some("L") => Action.L(num);
        | Some("R") => Action.R(num);
        | Some("F") => Action.F(num);
        | _ => Action.F(0);
    };
});

let init_ship = {
    facing: East,
    location: {x:0, y:0}
};
let rec turnLeft = (face: direction, angle: int) => {
    switch(face) {
        | _ when angle == 0 => face;
        | North => turnLeft(West, angle-1);
        | South => turnLeft(East, angle-1);
        | West => turnLeft(South, angle-1);
        | East => turnLeft(North, angle-1);
    }
}

let rec turnRight = (face: direction, angle: int) => {
    switch(face) {
        | _ when angle == 0 => face;
        | North => turnRight(East, angle-1);
        | South => turnRight(West, angle-1);
        | West => turnRight(North, angle-1);
        | East => turnRight(South, angle-1);
    }
}


module Ship = {
    let leftorRight = (ship, move:Action.t) => {
        switch(move) {
            | Action.L(angle) => {
                let turn = angle/90;
                {...ship, facing: turnLeft(ship.facing, turn)}
            }
            | Action.R(angle) => {
                let turn = angle/90;
                {...ship, facing: turnRight(ship.facing, turn)}
            }
            | _ => init_ship;
        }
    }
    let forward = (ship, move:Action.t) => {
        let direction = ship.facing;
        let distance = move->Action.getDistance
        switch(direction) {
            | North => {...ship, location: {x:ship.location.x, y:ship.location.y + distance}}
            | South => {...ship, location: {x:ship.location.x, y:ship.location.y - distance}}
            | East => {...ship, location: {y:ship.location.y, x:ship.location.x + distance}}
            | West => {...ship, location: {y:ship.location.y, x:ship.location.x - distance}}
        };
    };

    let horizontal = (ship, move:Action.t) => {
        switch(move) {
            | Action.E(v) => {...ship, location: {x: ship.location.x + v, y: ship.location.y}}
            | Action.W(v) => {...ship, location: {x: ship.location.x - v, y: ship.location.y}}
            | _ => ship
        };
    }

    let vertical = (ship, move:Action.t) => {
        switch(move) {
            | Action.N(v) => {...ship, location: {y: ship.location.y + v, x: ship.location.x}}
            | Action.S(v) => {...ship, location: {y: ship.location.y - v, x: ship.location.x}}
            | _ => ship
        };
    }

    let traverse = moves => {
        moves->List.reduce(init_ship, (acc,item) => {
            switch(item) {
                | Action.N(_) => vertical(acc, item)
                | Action.S(_) => vertical(acc, item)
                | Action.E(_) => horizontal(acc, item)
                | Action.W(_) => horizontal(acc, item)
                | Action.L(_) => leftorRight(acc, item)
                | Action.R(_) => leftorRight(acc, item)
                | Action.F(_) => forward(acc, item)
            }
        })
    }
}
type wayPoint = {
    facing_x: direction,
    facing_y: direction,
    x: int,
    y: int
};
type shipWithWayPoint = {
    location: point,
    wayPoint: wayPoint
};
module ShipWithWayPoint = {
    let initWayPoint = {
        facing_x: East,
        x: 10,
        facing_y: North,
        y: 1
    };
    let initShipWithWayPoint = {
        location: {x:0, y:0},
        wayPoint: initWayPoint
    };
    let leftorRight = (ship, move:Action.t) => {
        switch(move) {
            | Action.L(angle) => {
                let turn = angle/90;
                {...ship, wayPoint: {...ship.wayPoint, facing_x: turnLeft(ship.wayPoint.facing_x, turn), facing_y: turnLeft(ship.wayPoint.facing_y, turn)}}
            }
            | Action.R(angle) => {
                let turn = angle/90;
                {...ship, wayPoint: {...ship.wayPoint, facing_x: turnRight(ship.wayPoint.facing_x, turn), facing_y: turnRight(ship.wayPoint.facing_y, turn)}}
            }
            | _ => initShipWithWayPoint;
        }
    }

    let forward = (ship, wayPoint, multiplication: int) => {
        let direction_x = wayPoint.facing_x;
        let direction_y = wayPoint.facing_y;
        let distance_x = wayPoint.x * multiplication;
        let distance_y = wayPoint.y * multiplication;
        
        let x = switch(direction_x) {
            | North => {...ship, location: {x:ship.location.x, y:ship.location.y + distance_x}}
            | South => {...ship, location: {x:ship.location.x, y:ship.location.y - distance_x}}
            | East => {...ship, location: {x:ship.location.x + distance_x, y:ship.location.y}}
            | West => {...ship, location: {x:ship.location.x - distance_x, y:ship.location.y}}
        };

        switch(direction_y) {
            | North => {...x, location: {x:x.location.x, y:x.location.y + distance_y}}
            | South => {...x, location: {x:x.location.x, y:x.location.y - distance_y}}
            | East => {...x, location: {x:x.location.x + distance_y, y:x.location.y}}
            | West => {...x, location: {x:x.location.x - distance_y, y:x.location.y}}
        }
    };
    
    let horizontal = (ship, move:Action.t) => {
        switch(move) {
            | Action.E(v) => {
                switch(ship.wayPoint.facing_x) {
                    | East => {...ship, wayPoint: {...ship.wayPoint, x: ship.wayPoint.x + v}}
                    | West => {...ship, wayPoint: {...ship.wayPoint, x: ship.wayPoint.x + v}}
                    | _ => {
                        {...ship, wayPoint: {...ship.wayPoint, y: ship.wayPoint.y + v}}
                    }
                }
            }
            | Action.W(v) => {
                switch(ship.wayPoint.facing_x) {
                    | East => {...ship, wayPoint: {...ship.wayPoint, x: ship.wayPoint.x - v}}
                    | West => {...ship, wayPoint: {...ship.wayPoint, x: ship.wayPoint.x - v}}
                    | _ => {
                        {...ship, wayPoint: {...ship.wayPoint, y: ship.wayPoint.y - v}}
                    }
                }
            }
            | _ => ship
        };
    }

    let vertical = (ship, move:Action.t) => {
        switch(move) {
            | Action.N(v) => {
                switch(ship.wayPoint.facing_y) {
                    | North => {...ship, wayPoint: {...ship.wayPoint, y: ship.wayPoint.y + v}}
                    | South => {...ship, wayPoint: {...ship.wayPoint, y: ship.wayPoint.y + v}}
                    | _ => {
                        {...ship, wayPoint: {...ship.wayPoint, x: ship.wayPoint.x + v}}
                    }
                }
            }
            | Action.S(v) => {
                switch(ship.wayPoint.facing_y) {
                    | North => {...ship, wayPoint: {...ship.wayPoint, y: ship.wayPoint.y - v}}
                    | South => {...ship, wayPoint: {...ship.wayPoint, y: ship.wayPoint.y - v}}
                    | _ => {
                        {...ship, wayPoint: {...ship.wayPoint, x: ship.wayPoint.x - v}}
                    }
                }
            }
            | _ => ship
        };
    }

    let traverse = moves => {
        moves->List.reduce(initShipWithWayPoint, (acc,item) => {
            acc->Js.log
            switch(item) {
                | Action.N(_) => vertical(acc, item)
                | Action.S(_) => vertical(acc, item)
                | Action.E(_) => horizontal(acc, item)
                | Action.W(_) => horizontal(acc, item)
                | Action.L(_) => leftorRight(acc, item)
                | Action.R(_) => leftorRight(acc, item)
                | Action.F(_) => {
                    let multiply = item->Action.getDistance;
                    forward(acc, acc.wayPoint, multiply)
                }
            }
        })
    }
}

// input->parse->Ship.traverse.location->getDistance->Js.log
// Action.getDistance(Action.N(2))->Js.log
let part2 = input->parse->ShipWithWayPoint.traverse.location->getDistance;
input->parse->ShipWithWayPoint.traverse->Js.log
part2->Js.log
// input->parse->ShipWithWayPoint.traverse.location->getDistance->Js.log


