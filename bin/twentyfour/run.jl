input = joinpath(@__DIR__, "input")
hexes = readlines(input)

function chart(hexes)
    hs = Dict{CartesianIndex,Bool}()
    for hex in hexes
        i = 1
        dest = CartesianIndex(0, 0)
        while i <= length(hex)
            if hex[i:i] == "e"
                dest += CartesianIndex(1, 0)
                i += 1
            elseif hex[i:i] == "w"
                dest += CartesianIndex(-1, 0)
                i += 1
            elseif hex[i:i + 1] == "nw"
                dest += CartesianIndex(0, -1)
                i += 2
            elseif hex[i:i + 1] == "sw"
                dest += CartesianIndex(-1, 1)
                i += 2
            elseif hex[i:i + 1] == "ne"
                dest += CartesianIndex(1, -1)
                i += 2
            elseif hex[i:i + 1] == "se"
                dest += CartesianIndex(0, 1)
                i += 2
            end
        end
        flip!(hs, dest)
    end
    return hs
end

function flip!(hexes, dest)
    if haskey(hexes, dest)
        hexes[dest] = !hexes[dest]
    else
        hexes[dest] = true
    end
end

function adjacent(hex)
     adj = [
         CartesianIndex(1, 0),
         CartesianIndex(-1, 0),
         CartesianIndex(0, -1),
         CartesianIndex(-1, 1),
         CartesianIndex(1, -1),
         CartesianIndex(0, 1)
     ]
     return map(a -> hex + a, adj)
end

function game(hexes, rounds)
    next = copy(hexes)
    for _ in 1:rounds
        floor = next
        neighbors = Dict{CartesianIndex, Int}()
        for hex in keys(floor)
            if floor[hex]
                adj = adjacent(hex)
                for a in adj
                    haskey(neighbors, a) ? neighbors[a] = neighbors[a] + 1 : neighbors[a] = 1
                end
            end
        end
        next = Dict{CartesianIndex, Bool}()
        for (coord, count) in neighbors
            if haskey(floor, coord) && haskey(neighbors, coord) && floor[coord] && neighbors[coord] in [1, 2]
                next[coord] = true
            elseif neighbors[coord] == 2
                next[coord] = true
            end 
        end
    end
    return next
end

initial = chart(hexes)

p1 = length(filter(v -> v, collect(values(initial))))
p2 = length(filter(v -> v, collect(values(game(initial, 100)))))

println("-----------------------------------------------------------------------")
println("lobby layout -- part one :: $p1")
println("lobby layout -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 420)
@assert(p2 == 4206)