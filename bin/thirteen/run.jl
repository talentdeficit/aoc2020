using Test, Mods

sample = joinpath(@__DIR__, "sample")
example = readlines(sample)

input = joinpath(@__DIR__, "input")
lines = readlines(input)

function prepare(input)
    now = parse(Int, input[1])
    schedule = map(id -> id == "x" ? missing : parse(Int, id), split(input[2], ","))
    return (now, schedule)
end

function busses(schedule)
    return [(id, idx - 1) for (idx, id) in enumerate(schedule) if !ismissing(id)]
end

function ids(busses)
    return first.(busses)
end

function offsets(busses)
    return last.(busses)
end

function depart(now, schedule)
    wait, id = minimum(map(id -> (mod(-1 * now, id), id), filter(!ismissing, schedule)))
    return id * wait
end

function solver(schedule)
    targets = busses(schedule)
    (period, t) = first(targets)
    for idx in 2:length(targets)
        (candidate, offset) = targets[idx]
        while ((t + offset) % candidate != 0)
            t += period
        end
        period *= candidate
    end
    return t
end

(now, schedule) = prepare(example)

@test depart(now, schedule) == 295
@test solver(schedule) == 1068781

(now, schedule) = prepare(lines)

p1 = depart(now, schedule)
p2 = solver(schedule)

@assert(p1 == 104)
@assert(p2 == 842186186521918)

println("-----------------------------------------------------------------------")
println("shuttle search -- part one :: $p1")
println("shuttle search -- part two :: $p2")
println("-----------------------------------------------------------------------")
