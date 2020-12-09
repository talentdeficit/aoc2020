using Test, Match

input = joinpath(@__DIR__, "input")
program = readlines(input)

struct Op
    code::String
    value::Int
end

function parse_program(p)
    return map(parse_op, p)
end

function parse_op(op)
    code = op[1:3]
    val = parse(Int, op[5:end])
    return Op(code, val)
end

function run(program, ptr = 1)
    acc = 0
    visited = Set{Int}()
    bound = length(program)
    while !(ptr in visited) && ptr > 0 && ptr <= bound
        op = program[ptr]
        code = op.code
        val = op.value
        push!(visited, ptr)
        @match code begin
            "acc" => begin acc += val; ptr += 1 end
            "jmp" => begin ptr += val end
            "nop" => begin ptr += 1 end
        end
    end
    complete = ptr == length(program) + 1
    return [complete, acc, visited]
end

function mutate(program, visited)
    winning = Set{Int}()
    losing = Set{Int}()
    for i in 1:length(program)
        res = run(program, i)
        res[1] ? push!(winning, i) : push!(losing, i)
    end
    for i in visited
        op = program[i]
        if op.code == "jmp"
            if i + 1 in winning
                new = Op("nop", op.value)
                dup = copy(program)
                dup[i] = new
                return dup
            end
        elseif op.code == "nop"
            if i + op.value in winning
                new = Op("jmp", op.value)
                dup = copy(program)
                dup[i] = new
                return dup
            end
        end 
    end
end

prog = parse_program(program)
r1 = run(prog)

p1 = r1[2]

mutant = mutate(prog, r1[3])
r2 = run(mutant)
p2 = r2[2]

@assert(p1 == 1489)
@assert(p2 == 1539)


sample = [
    "nop +0",
    "acc +1",
    "jmp +4",
    "acc +3",
    "jmp -3",
    "acc -99",
    "acc +1",
    "jmp -4",
    "acc +6"
]

t = parse_program(sample)
r = run(t)
m = mutate(t, r[3])
v = run(m)

@test r[2] == 5
@test r[1] == false

@test v[2] == 8
@test v[1] == true



println("-----------------------------------------------------------------------")
println("handheld halting -- part one :: $p1")
println("handheld halting -- part two :: $p2")
println("-----------------------------------------------------------------------")
