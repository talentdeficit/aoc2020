using Match

input = joinpath(@__DIR__, "input")
cmds = readlines(input)

mutable struct Ship
    waypoint::CartesianIndex
    orientation::Array{CartesianIndex,1}
    location::CartesianIndex
end

function move!(ship, commands, movementfn)
    for cmd in commands
        instruction = cmd[1:1]
        value = parse(Int, cmd[2:end])
        movementfn(ship, instruction, value)
    end
end

function direct!(ship::Ship, instruction::String, value::Int)
    @match instruction begin
        "N" => begin ship.location += CartesianIndex(0, value) end
        "S" => begin ship.location += CartesianIndex(0, -1 * value) end
        "W" => begin ship.location += CartesianIndex(value, 0) end
        "E" => begin ship.location += CartesianIndex(-1 * value, 0) end
        "L" => begin
            for steps in 1:(value / 90)
                reverse!(ship.orientation)
                prepend!(ship.orientation, [pop!(ship.orientation)])
                reverse!(ship.orientation)
            end
        end
        "R" => begin
            for steps in 1:(value / 90)
                prepend!(ship.orientation, [pop!(ship.orientation)])
            end
        end
        "F" => begin
            (dx, dy) = Tuple(first(ship.orientation))
            (sx, sy) = Tuple(ship.location)
            ship.location = CartesianIndex(sx + (dx * value), sy + (dy * value))
        end
    end
end

function waypoint!(ship::Ship, instruction::String, value::Int)
    @match instruction begin
        "N" => begin ship.waypoint += CartesianIndex(0, value) end
        "S" => begin ship.waypoint += CartesianIndex(0, -1 * value) end
        "W" => begin ship.waypoint += CartesianIndex(value, 0) end
        "E" => begin ship.waypoint += CartesianIndex(-1 * value, 0) end
        "L" => begin
            (wx, wy) = Tuple(ship.waypoint)
            for steps in 1:(value / 90)
                tmp = wx
                wx = wy
                wy = -1 * tmp
            end
            ship.waypoint = CartesianIndex(wx, wy)
        end
        "R" => begin
            (wx, wy) = Tuple(ship.waypoint)
            for steps in 1:(value / 90)
                tmp = wy
                wy = wx
                wx = -1 * tmp
            end
            ship.waypoint = CartesianIndex(wx, wy)
        end
        "F" => begin
            (wx, wy) = Tuple(ship.waypoint)
            (sx, sy) = Tuple(ship.location)
            v = CartesianIndex(wx * value, wy * value)
            ship.location += v
        end
    end
end

ship = Ship(
    CartesianIndex(0, 0),
    [CartesianIndex(0, -1), CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(1, 0)],
    CartesianIndex(0, 0)
)

move!(ship, cmds, direct!)
(fx, fy) = Tuple(ship.location)
p1 = abs(fx) + abs(fy)

ship = Ship(
    CartesianIndex(-10, 1),
    [],
    CartesianIndex(0, 0)
)

move!(ship, cmds, waypoint!)
(fx, fy) = Tuple(ship.location)
p2 = abs(fx) + abs(fy)

@assert(p1 == 323)
@assert(p2 == 42495)

println("-----------------------------------------------------------------------")
println("rain risk -- part one :: $p1")
println("rain risk -- part two :: $p2")
println("-----------------------------------------------------------------------")