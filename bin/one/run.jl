using DelimitedFiles

input = joinpath(@__DIR__, "input")
entries = readdlm(input, Int)

p1 = 0
p2 = 0

for i in 1:(length(entries))
    for j in (i + 1):(length(entries))
        if entries[i] + entries[j] == 2020
            global p1 = entries[i] * entries[j]
        end
        for k in (j + 1):(length(entries))
            if entries[i] + entries[j] + entries[k] == 2020
                global p2 = entries[i] * entries[j] * entries[k]
                break
            end
        end
    end
end

println("-----------------------------------------------------------------------")
println("report repair -- part one :: $p1")
println("report repair -- part two :: $p2")
println("-----------------------------------------------------------------------")