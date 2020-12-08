using DelimitedFiles

input = joinpath(@__DIR__, "input")
entries = readdlm(input, Int)

function twosum(entries)
    for i in 1:(length(entries))
        for j in (i + 1):(length(entries))
            if entries[i] + entries[j] == 2020
                return entries[i] * entries[j]
            end
        end
    end

    return 0
end

function threesum(entries)
    for i in 1:(length(entries))
        for j in (i + 1):(length(entries))
            for k in (j + 1):(length(entries))
                if entries[i] + entries[j] + entries[k] == 2020
                    return entries[i] * entries[j] * entries[k]
                end
            end
        end
    end

    return 0
end


p1 = twosum(entries)
p2 = threesum(entries)

@assert(p1 == 876459)
@assert(p2 == 116168640)

println("-----------------------------------------------------------------------")
println("report repair -- part one :: $p1")
println("report repair -- part two :: $p2")
println("-----------------------------------------------------------------------")