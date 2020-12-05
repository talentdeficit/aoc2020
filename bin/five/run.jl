using Test

input = joinpath(@__DIR__, "input")
passes = readlines(input)

# our boarding pass is a thinly disguised 10 bit integer
const factors = [512, 256, 128, 64, 32, 16, 8, 4, 2, 1]
const translator = Dict('F' => 0, 'L' => 0, 'B' => 1, 'R' => 1) 

function seat(pass)
  bin = map(c -> translator[c], collect(pass))
  return sum(bin .* factors)
end

function findseat(seatids)
  allpossible = collect(minimum(seatids):maximum(seatids))
  return only(filter(i -> !(i in seatids), allpossible))
end

seatids = map(p -> seat(p), passes)

p1 = maximum(seatids)
p2 = findseat(seatids)

@assert(p1 == 994)
@assert(p2 == 741)

@test seat("BFFFBBFRRR") == 567
@test seat("FFFBBBFRRR") == 119
@test seat("BBFFBBFRLL") == 820

println("-----------------------------------------------------------------------")
println("binary boarding -- part one :: $p1")
println("binary boarding -- part two :: $p2")
println("-----------------------------------------------------------------------")
