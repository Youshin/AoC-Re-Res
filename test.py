with open("src/input/day12.txt", "r") as fp:
    lines = [(line.rstrip()[0], int(line.rstrip()[1:]))  for line in fp.readlines()]
dirs = ["E", "S", "W", "N", "L", "R", "F"]
curr_dir = "E"

curr_state = {"E":0, "W":0, "N":0, "S":0}

for line in lines:
    if line[0] == "F":
        curr_state[curr_dir] += line[1]

    if line[0] == "R":
        av = ["E", "S", "W", "N"]
        angle = line[1]
        v = int(angle/90)
        ndir = (av.index(curr_dir)+v) % len(av)
        ndir = av[ndir]
        curr_dir = ndir

    if line[0] == "L":
        av = ["E", "N", "W", "S"]
        angle = line[1]
        v = int(angle/90)
        ndir = (av.index(curr_dir)+v) % len(av)
        ndir = av[ndir]
        curr_dir = ndir


    if line[0] == "N":
        curr_state["N"] += line[1]
    if line[0] == "S":
        curr_state["S"] += line[1]
    if line[0] == "W":
        curr_state["W"] += line[1]
    if line[0] == "E":
        curr_state["E"] += line[1]

d = curr_state["E"]-curr_state["W"], curr_state["S"]-curr_state["N"]
print(f"Manhattan Distance of current positions from starting i.e. {curr_state} = {d[0]+d[1]}")    

import math

def rotate(origin, point, angle):
    ox, oy = origin
    px, py = point
    qx = ox + math.cos(angle) * (px - ox) - math.sin(angle) * (py - oy)
    qy = oy + math.sin(angle) * (px - ox) + math.cos(angle) * (py - oy)
    return int(round(qx)), int(round(qy))

coord = {'x': 0, 'y': 0}
waypoint = {'x': 10, 'y': 1}
for line in lines:
    instruction, n = line
    if instruction == 'N':
        waypoint['y'] += n
    elif instruction == 'S':
        waypoint['y'] -= n
    elif instruction == 'E':
        waypoint['x'] += n
    elif instruction == 'W':
        waypoint['x'] -= n
    elif instruction == 'F':
        coord['y'] += waypoint['y'] * n
        coord['x'] += waypoint['x'] * n
    elif instruction in ['L', 'R']:
        if instruction == 'R':
            n = -n
        waypoint['x'], waypoint['y'] = rotate(
            (0, 0), (waypoint['x'], waypoint['y']), math.radians(n)
        )
print(abs(coord['x']) + abs(coord['y']))