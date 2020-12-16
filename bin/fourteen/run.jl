using Test

input = joinpath(@__DIR__, "sample")
sample = readlines(input)

input = joinpath(@__DIR__, "input")
problem = readlines(input)

const MASK = r"^mask = (.+)$"
const MEM = r"^mem\[(\d+)\] = (\d+)$"

const V1 = 1
const V2 = 2

function decode(mask)
    ksam = reverse(mask)
    on = reduce(|, map(x -> 1 << (x - 1), findall(==('1'), ksam)))
    off = ~reduce(|, map(x -> 1 << (x - 1), findall(==('0'), ksam)))
    return (on, off)
end

function floatingbits(mask)
    bitsets = powerset(findall(==('X'), reverse(mask)))
    return map(bitset -> reduce(|, map(x -> 1 << (x - 1), bitset); init=0), bitsets)
end

function powerset(x)
    result = [[]]
    for elem in x, j in eachindex(result)
        push!(result, [result[j] ; elem])
    end
    return result
end

function run(program, version)
    registers = Dict{Int, Int}()
    on = 0
    off = 0
    floating = []

    for instruction in program
        if (m = match(MASK, instruction); !isnothing(m))
            mask = first(m.captures)
            (on, off) = decode(mask)
            version == V2 ? floating = floatingbits(mask) : floating = []
        elseif (m = match(MEM, instruction); !isnothing(m) && version == 1)
            addr = parse(Int, first(m.captures))
            val = parse(Int, last(m.captures))
            registers[addr] = (val | on) & off
        elseif (m = match(MEM, instruction); !isnothing(m) && version == 2)
            addr = (parse(Int, first(m.captures)) | on) & ~(maximum(floating))
            val = parse(Int, last(m.captures))
            for f in floating
                registers[(addr | f)] = val
            end
        end
    end

    return registers
end

function calc(registers)
    return sum(values(registers))
end

registers = Dict{Int, Int}()

r = run(sample, V1)
# don't uncomment this unless you have a quantum computer
# r2 = run(sample, V2)

@test calc(r) == 165


r = run(problem, V1)
r2 = run(problem, V2)

p1 = calc(r)
p2 = calc(r2)

@assert(p1 == 10035335144067)
@assert(p2 == 3817372618036)

println("-----------------------------------------------------------------------")
println("docking data -- part one :: $p1")
println("docking data -- part two :: $p2")
println("-----------------------------------------------------------------------")
