using Match

input = joinpath(@__DIR__, "input")
cmds = readlines(input)

@enum Opmode direct waypoint

mutable struct Ship
    waypoint::Array{Int,1}
    location::Array{Int,1}
    opmode::Opmode
end

const rturn = [0 -1 ; 1 0]
const lturn = [0 1 ; -1 0]

function move!(ship, commands)
    for cmd in commands
        instruction = cmd[1:1]
        value = parse(Int, cmd[2:end])
        move!(ship, instruction, value)
    end
end

function move!(ship::Ship, instruction::String, value::Int)
    @match instruction begin
        "N", if ship.opmode == direct end => begin ship.location += [0, value] end
        "S", if ship.opmode == direct end => begin ship.location += [0, -1 * value] end
        "W", if ship.opmode == direct end => begin ship.location += [value, 0] end
        "E", if ship.opmode == direct end => begin ship.location += [-1 * value, 0] end
        "N", if ship.opmode == waypoint end => begin ship.waypoint += [0, value] end
        "S", if ship.opmode == waypoint end => begin ship.waypoint += [0, -1 * value] end
        "W", if ship.opmode == waypoint end => begin ship.waypoint += [value, 0] end
        "E", if ship.opmode == waypoint end => begin ship.waypoint += [-1 * value, 0] end
        "L" => begin ship.waypoint = lturn^(value / 90) * ship.waypoint end
        "R" => begin ship.waypoint = rturn^(value / 90) * ship.waypoint end
        "F" => begin ship.location += ship.waypoint * value end
    end
end

ship = Ship(
    [-1, 0],
    [0, 0],
    direct
)

move!(ship, cmds)
(fx, fy) = Tuple(ship.location)
p1 = abs(fx) + abs(fy)


ship = Ship(
    [-10, 1],
    [0, 0],
    waypoint
)

move!(ship, cmds)
(fx, fy) = Tuple(ship.location)
p2 = abs(fx) + abs(fy)

@assert(p1 == 445)
@assert(p2 == 42495)

println("-----------------------------------------------------------------------")
println("rain risk -- part one :: $p1")
println("rain risk -- part two :: $p2")
println("-----------------------------------------------------------------------")