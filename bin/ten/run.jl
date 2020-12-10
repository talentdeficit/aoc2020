using Test

input = joinpath(@__DIR__, "input")
in = readlines(input)

adapters = map(x -> parse(Int, x), in)

function joltage(adapters)
    append!(adapters, 0)
    append!(adapters, maximum(adapters) + 3)
    sort!(adapters)

    deltas = diff(adapters)
    one = length(filter(x -> x == 1, deltas))
    three = length(filter(x -> x == 3, deltas))
    return one * three
end

function arrangements(adapters)
    append!(adapters, 0)
    append!(adapters, maximum(adapters) + 3)
    sort!(adapters)
    
    return arrangements(adapters, 1, Dict{Int, Int}())
end

function arrangements(adapters, idx, cache)
    haskey(cache, idx) && return cache[idx]
    idx == length(adapters) && return 1
    one = adapters[idx + 1] - adapters[idx] <= 3 ? arrangements(adapters, idx + 1, cache) : 0
    two = idx + 2 <= length(adapters) && adapters[idx + 2] - adapters[idx] <= 3 ? arrangements(adapters, idx + 2, cache) : 0
    three = idx + 3 <= length(adapters) && adapters[idx + 3] - adapters[idx] <= 3 ? arrangements(adapters, idx + 3, cache) : 0
    cache[idx] = one + two + three
    return one + two + three
end

sample = [
    16,
    10,
    15,
    5,
    1,
    11,
    7,
    19,
    6,
    12,
    4
]

@test joltage(copy(sample)) == 7 * 5
@test arrangements(copy(sample)) == 8

p1 = joltage(copy(adapters))
p2 = arrangements(copy(adapters))

@assert(p1 == 1984)
@assert(p2 == 3543369523456)

println("-----------------------------------------------------------------------")
println("adapter array -- part one :: $p1")
println("adapter array -- part two :: $p2")
println("-----------------------------------------------------------------------")