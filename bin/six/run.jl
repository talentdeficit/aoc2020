input = joinpath(@__DIR__, "input")
answers = read(input, String)

groups = map(group -> split(group, "\n"), split(answers, "\n\n"))

p1 = sum(map(qs -> length(qs), map(group -> reduce(union, group), groups)))
p2 = sum(map(qs -> length(qs), map(group -> reduce(intersect, group), groups)))

@assert(p1 == 7120)
@assert(p2 == 3570)

println("-----------------------------------------------------------------------")
println("custom customs -- part one :: $p1")
println("custom customs -- part two :: $p2")
println("-----------------------------------------------------------------------")