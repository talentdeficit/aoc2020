using Match

input = joinpath(@__DIR__, "input")
input = readlines(input)

INACTIVE = "."
ACTIVE = "#"

initial = map(line -> split(line, ""), input)
initial = reshape(vcat(initial...), :, length(initial))

function locate(initial, dims)
    (x, y) = size(initial)
    locs = []
    for i in 1:x
        for j in 1:y
            if initial[CartesianIndex(i, j)] == ACTIVE
                array = zeros(Int, dims)
                array[1] = i; array[2] = j
                push!(locs, CartesianIndex(array...))
            end
        end
    end
    return locs
end

function adjacent(dims)
    arr = zeros(Int, dims)
    origin = CartesianIndex(arr...)
    return filter(coord -> coord != origin, CartesianIndices((repeat([-1:1], dims)...,)))
end

function iter(sources, dims, cycles)
    next = Set(copy(sources))
    for _ in 1:cycles
        field = next
        neighbors = Dict{CartesianIndex{dims}, Int}()
        for source in field
            for adj in map(coord -> coord + source, adjacent(dims))
                haskey(neighbors, adj) ? neighbors[adj] = neighbors[adj] + 1 : neighbors[adj] = 1
            end
        end
        next = Set{CartesianIndex{dims}}()
        for (coord, count) in neighbors
            count == 3 && push!(next, coord)
            coord in field && count in 2:3 && push!(next, coord)
        end
    end
    return collect(next)
end


dims = 3
locs = locate(initial, dims)
locs = iter(locs, dims, 6)
p1 = length(locs)



dims = 4
locs = locate(initial, dims)
locs = iter(locs, dims, 6)
p2 = length(locs)

@assert(p1 == 257)
@assert(p2 == 2532)

println("-----------------------------------------------------------------------")
println("conway cubes -- part one :: $p1")
println("conway cubes -- part two :: $p2")
println("-----------------------------------------------------------------------")