using DelimitedFiles

input = joinpath(@__DIR__, "input")
raw = readdlm(input, String)

struct Point
    x::Int64
    y::Int64
end

function trees(map)
    coords = Set{Point}()
    for i = 1:length(map)
        for j = 1:length(map[i])
            if map[i][j] == '#'
                push!(coords, Point(j, i))
            end
        end
    end
    return coords
end

function solve(map, rx, ry, w, h)
    hits = 0
    pos = Point(1, 1)
    for i = 1:(h - 1)
        nx = mod1(pos.x + rx, w)
        ny = pos.y + ry
        pos = Point(nx, ny)
        if in(pos, map)
            hits += 1
        end
    end
    return hits
end

const w = length(raw[1])
const h = length(raw)

map = trees(raw)
p1 = solve(map, 3, 1, w, h)

slopes = ((1,1), (3,1), (5,1), (7,1), (1,2))

p2 = prod(solve(map, rx, ry, w, h) for (rx, ry) in slopes)

println("-----------------------------------------------------------------------")
println("toboggan trajectory -- part one :: $p1")
println("toboggan trajectory -- part two :: $p2")
println("-----------------------------------------------------------------------")