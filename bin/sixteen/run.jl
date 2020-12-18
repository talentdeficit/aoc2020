using Test

input = read(joinpath(@__DIR__, "input"), String)

RE = r"^([a-zA-Z ]+): (\d+)-(\d+) or (\d+)-(\d+)$"

function parse_input(input)
    parts = split(input, "\n\n")
    notes = split(first(parts), "\n")
    myticket = split(parts[2], "\n")
    othertickets = split(parts[3], "\n")
    tickets = append!(myticket[2:end], othertickets[2:end])
    return (notes, tickets)
end

function parse_notes(notes)
    acc = []
    for note in notes
        m = match(RE, note)
        rule = m.captures[1]
        bounds = map(x -> parse(Int, x), m.captures[2:5])
        r1 = bounds[1]:bounds[2]
        r2 = bounds[3]:bounds[4]
        push!(acc, (rule, r1, r2))
    end
    return acc
end

function parse_tickets(tickets)
    return map(t -> map(x -> parse(Int, x), split(t, ",")), filter(!isempty, tickets))
end

function filter_tickets(tickets, ranges)
    return filter(t -> length(check_ticket(t, ranges)) == 0, tickets)
end

function check_tickets(tickets, ranges)
    acc = []
    for ticket in tickets
        append!(acc, check_ticket(ticket, ranges))
    end
    return acc
end

function check_ticket(ticket, ranges)
    return filter(n -> !check_value(n, ranges), ticket)
end

function check_value(n, ranges)
    return any(map(r -> check_range(n, r), ranges))
end

function check_range(n, r)
    (_, r1, r2) = r
    return n in r1 || n in r2
end

function possibilities(tickets::Array{Array{Int, 1}, 1}, ranges)
    return map(t -> possibilities(t, ranges), tickets)
end

function possibilities(ticket::Array{Int,1}, ranges)
    return map(v -> possibilities(v, ranges), ticket)
end

function possibilities(value::Int, ranges)
    return filter(!isnothing, map(r -> rules(value, r), ranges))
end

function rules(value, range)
    (rule, r1, r2) = range
    return (value in r1 || value in r2) ? rule : nothing
end

function flat(ps)
    rules = Dict{Int, Array{String,1}}()
    for i in 1:length(first(ps))
        r = reduce(intersect!, map(p -> p[i], ps))
        rules[i] = r
    end

    result = Dict{Int, String}()
    seen = []

    while length(result) < 20
        for (k, v) in rules
            left = setdiff(v, seen)
            if length(left) == 1
                append!(seen, left)
                result[k] = left[1]
            end
        end
    end

    return result
end

(ns, ts) = parse_input(input)

notes = parse_notes(ns)
tickets = parse_tickets(ts)

p1 = sum(check_tickets(tickets, notes))

valid = filter_tickets(tickets[2:end], notes)
ps = flat(possibilities(valid, notes))

fields = map(first, filter(kv -> startswith(kv.second, "departure "), collect(ps)))

myticket = tickets[1]
p2 = prod(map(field -> myticket[field], fields))

println("-----------------------------------------------------------------------")
println("docking data -- part one :: $p1")
println("docking data -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 27870)
@assert(p2 == 3173135507987)