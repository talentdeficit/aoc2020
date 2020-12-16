using Test

ns = [14, 1, 17, 0, 3, 20]

function saidwhen(ns)
    return Dict([(n, i) for (i, n) in enumerate(ns)])
end

function play(sofar, target)
    ns = copy(sofar)
    said = saidwhen(ns)
    turn = length(sofar)
    
    while turn < target
        last = ns[turn]
        if !haskey(said, last)
            append!(ns, 0)
            said[last] = turn
        else
            append!(ns, turn - said[last])
            said[last] = turn
        end
        turn += 1
    end
    return ns
end

@test last(play([0, 3, 6], 10)) == 0
@test last(play([1, 3, 2], 2020)) == 1
@test last(play([2, 1, 3], 2020)) == 10
@test last(play([1, 2, 3], 2020)) == 27
@test last(play([2, 3, 1], 2020)) == 78
@test last(play([3, 2, 1], 2020)) == 438
@test last(play([3, 1, 2], 2020)) == 1836

p1 = last(play(ns, 2020))
p2 = last(play(ns, 30000000))

@assert(p1 == 387)
@assert(p2 == 6428)

println("-----------------------------------------------------------------------")
println("rambunctious recitation -- part one :: $p1")
println("rambunctious recitation -- part two :: $p2")
println("-----------------------------------------------------------------------")