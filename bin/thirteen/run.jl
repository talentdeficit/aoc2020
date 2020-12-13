using Test, Mods

sample = joinpath(@__DIR__, "sample")
example = readlines(sample)

input = joinpath(@__DIR__, "input")
lines = readlines(input)

function depart(schedule)
    now = parse(Int, schedule[1])
    ids = map(id -> id == "x" ? missing : parse(Int, id), split(schedule[2], ","))
    wait, id = minimum(map(id -> (mod(-1 * now, id), id), filter(!ismissing, ids)))
    return id * wait
end

function contest(schedule)
    ids = map(id -> id == "x" ? missing : parse(Int, id), split(schedule[2], ","))
    ids = filter(pr -> !ismissing(pr[2]), map(pr -> (pr[1] - 1, pr[2]), enumerate(ids)))
    n = []
    a = []
    mods = [Mod{id}(-1 * i) for (i, id) in ids]
    return CRT(mods...).val
end

@test depart(example) == 295
@test contest(example) == 1068781

p1 = depart(lines)
p2 = contest(lines)

@assert(p1 == 104)
@assert(p2 == 842186186521918)

println("-----------------------------------------------------------------------")
println("shuttle search -- part one :: $p1")
println("shuttle search -- part two :: $p2")
println("-----------------------------------------------------------------------")