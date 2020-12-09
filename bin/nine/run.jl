using Test

input = joinpath(@__DIR__, "input")
thing = map(x -> parse(Int, x), readlines(input))

preamble = thing[1:25]
numbers = thing[26:end]

function calculate(n, preamble)
    for m in preamble
        if (n - m) in preamble
            return true
        end
    end
    return false
end

function calibrate(numbers, preamble)
    for n in numbers
        if !calculate(n, preamble)
            return n
        end
        push!(preamble, n)
        popfirst!(preamble)
    end
end

p1 = calibrate(numbers, preamble)

function crack(target, seq)
    for i in 1:length(seq)
        for j in i:length(seq)
            slice = seq[i:j]
            s = sum(slice)
            if s == target
                return minimum(slice) + maximum(slice)
            elseif s > target
                break
            end
        end
    end
end

p2 = crack(p1, thing)

@assert(p1 == 23278925)
@assert(p2 == 4011064)

sample = [
    35,
    20,
    15,
    25,
    47,
    40,
    62,
    55,
    65,
    95,
    102,
    117,
    150,
    182,
    127,
    219,
    299,
    277,
    309,
    576
]

@test calibrate(sample[6:end], sample[1:5]) == 127
@test crack(127, sample) == 62

println("-----------------------------------------------------------------------")
println("encoding error -- part one :: $p1")
println("encoding error -- part two :: $p2")
println("-----------------------------------------------------------------------")
