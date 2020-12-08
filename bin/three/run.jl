using DelimitedFiles

input = joinpath(@__DIR__, "input")
map = readdlm(input, String)

function solve(map, slope, bounds)
    hits = 0
    pos = CartesianIndex(1, 1)
    pos += slope
  
    while pos[1] <= bounds[1]
        x = pos[2]
        y = pos[1]
        hits += (map[y][x] == '#' ? 1 : 0)
        pos += slope
        pos[2] > bounds[2] && (pos -= CartesianIndex(0, bounds[2]))
    end
    return hits
end

const bounds = CartesianIndex(length(map), length(map[1]))

p1 = solve(map, CartesianIndex(1, 3), bounds)

const slopes = (CartesianIndex(1, 1), CartesianIndex(1, 3), CartesianIndex(1, 5), CartesianIndex(1, 7), CartesianIndex(2, 1))

p2 = prod(solve(map, slope, bounds) for slope in slopes)

@assert(p1 == 299)
@assert(p2 == 3621285278)

println("-----------------------------------------------------------------------")
println("toboggan trajectory -- part one :: $p1")
println("toboggan trajectory -- part two :: $p2")
println("-----------------------------------------------------------------------")