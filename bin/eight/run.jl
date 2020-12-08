using Test, Match

input = joinpath(@__DIR__, "input")
program = readlines(input)

function parse_program(p)
    return map(parse_op, p)
end

function parse_op(op)
    return Pair(op[1:3], parse(Int, op[5:end]))

end

function run(program)
    @show(length(program))
    acc = 0
    int = 1
    exec = Set{Int}()
    while !(int in exec) && int <= length(program)
        (op, value) = program[int]
        push!(exec, int)
        @match op begin
            "acc" => begin acc += value; int += 1 end
            "jmp" => begin int += value end
            "nop" => begin int += 1 end
        end
    end
    fault = int <= length(program) ? true : false
    return Pair(acc, fault)
end

function mutate(program, idx)
    instruction = program[idx]
    dup = copy(program)
    if instruction.first == "jmp"
        dup[idx] = Pair("nop", instruction.second)
        return dup
    elseif instruction.first == "nop"
        dup[idx] = Pair("jmp", instruction.second)
        return dup
    end
    return dup
end

prog = parse_program(program)
res = run(prog)

p1 = res.first

mutants = map(x -> mutate(prog, x), 1:length(prog))

p2 = 0
for mutant in mutants
    r = run(mutant)
    if r.second == true
        global p2 = r.first
        break
    end
end

@assert(p1 == 1489)
@assert(p2 == 1539)



t = parse_program([
"nop +0",
"acc +1",
"jmp +4",
"acc +3",
"jmp -3",
"acc -99",
"acc +1",
"jmp -4",
"acc +6"
])
r = run(t)


@test r.first == 5
@test r.second == false

println("-----------------------------------------------------------------------")
println("handheld halting -- part one :: $p1")
println("handheld halting -- part two :: $p2")
println("-----------------------------------------------------------------------")
