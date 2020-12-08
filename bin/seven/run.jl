input = joinpath(@__DIR__, "input")
raw = readlines(input)

struct Rule 
    outer
    inner
    quantity
end

rcontainer = r"^([a-z]+ [a-z]+) bags contain "
rbags = r"(\d+) ([a-z]+ [a-z]+)"

function parserule(rule)
    color = match(rcontainer, rule).captures[1]
    return map(m -> Rule(color, m.captures[2], parse(Int, m.captures[1])), collect(eachmatch(rbags, rule)))
end

rules = reduce(append!, map(parserule, raw))

function cancontain(rules, color)
    return map(r -> Pair(r.inner, r.quantity), filter(r -> r.outer == color, rules))
end

function containedby(rules, color)
    return unique(map(r -> r.outer, filter(r -> r.inner == color, rules)))
end

function countcontainers(rules, colors)
    queue = Set(colors)
    tried = Set{String}()
    while !isempty(queue)
        color = pop!(queue)
        more = containedby(rules, color)
        for m in more
            push!(queue, m)
        end
        push!(tried, color)
    end
    return length(tried)
end

function countcontained(rules, colors)
    queue = Set(colors)
    count = 0
    while !isempty(queue)
        next = pop!(queue)
        col = next.first
        qty = next.second
        count += qty
        for (k, v) in cancontain(rules, col)
            push!(queue, Pair(k, qty * v))
        end
    end
    return count
end

p1 = countcontainers(rules, containedby(rules, "shiny gold"))
p2 = countcontained(rules, cancontain(rules, "shiny gold"))

@assert(p1 == 226)
@assert(p2 == 9569)

println("-----------------------------------------------------------------------")
println("handy haversacks -- part one :: $p1")
println("handy haversacks -- part two :: $p2")
println("-----------------------------------------------------------------------")