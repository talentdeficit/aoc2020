using Test

input = joinpath(@__DIR__, "input")
lines = readlines(input)

DIRECTIONS = [
    CartesianIndex(-1,0),
    CartesianIndex(1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(0, -1),
    CartesianIndex(1, 1),
    CartesianIndex(1, -1),
    CartesianIndex(-1, 1),
    CartesianIndex(-1, -1)
]

FLOOR = '.'
TAKEN = '#'
OPEN = 'L'

function parse_seating(input)
    return mapreduce(collect, hcat, input) |> permutedims
end

function pp(seating)
    (x, y) = size(seating)
    s = deepcopy(seating) |> permutedims
    for j in 1:x
        for i in 1:y
            print(seating[CartesianIndex(j, i)])
        end
        println()
    end
    println()
end

function v1mutate(seating)
    dims = size(seating)
    next = fill('.', dims)
    for indice in eachindex(seating)
        state = seating[indice]
        if state == TAKEN || state == OPEN
            loc = CartesianIndices(seating)[indice]
            neighbors = map(dir -> loc + dir, DIRECTIONS)
            occupied = length(filter(neighbor -> checkbounds(Bool, seating, neighbor) && seating[neighbor] == TAKEN, neighbors))
            if state == OPEN && occupied == 0
                next[indice] = TAKEN
            elseif state == TAKEN && occupied >= 4
                next[indice] = OPEN
            else
                next[indice] = state
            end
        end
    end
    return next
end

function v2mutate(seating)
    dims = size(seating)
    next = fill('.', dims)
    for indice in eachindex(seating)
        state = seating[indice]
        if state == TAKEN || state == OPEN
            loc = CartesianIndices(seating)[indice]
            occupied = length(filter(r -> r, map(direction -> see(seating, loc, direction), DIRECTIONS)))
            if state == OPEN && occupied == 0
                next[indice] = TAKEN
            elseif state == TAKEN && occupied >= 5
                next[indice] = OPEN
            else
                next[indice] = state
            end
        end
    end
    return next
end

function see(seating, origin, direction)
    indice = origin + direction
    while checkbounds(Bool, seating, indice)
        seating[indice] == TAKEN && return true
        seating[indice] == OPEN && return false
        indice += direction
    end
    return false
end

function stabilize(seating, mutator)
    current = deepcopy(seating)
    next = mutator(current)
    while current != next
        current = next
        next = mutator(current)
    end
    return current
end

function count_occupied(seating)
    vals = collect(values(seating))
    return length(filter(s -> s == TAKEN, vals))
end

seating = parse_seating(lines)

final = stabilize(seating, v1mutate)
p1 = count_occupied(final)

final = stabilize(seating, v2mutate)
p2 = count_occupied(final)

@assert(p1 == 2346)
@assert(p2 == 2111)

println("-----------------------------------------------------------------------")
println("seating system -- part one :: $p1")
println("seating system -- part two :: $p2")
println("-----------------------------------------------------------------------")