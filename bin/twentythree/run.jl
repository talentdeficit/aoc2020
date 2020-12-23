sample = [3, 8, 9, 1, 2, 5, 4, 6, 7]
input = [1, 2, 3, 4, 8, 7, 5, 9, 6]

mutable struct Cup
    val::Int
    next::Union{Cup,Nothing}
end

function link!(cups)
    for i in 1:length(cups)
        next = i + 1 > length(cups) ? 1 : i + 1
        cups[i].next = cups[next]
    end
end

function play!(cups, rounds)
    addresses = Dict()
    for cup in cups
        addresses[cup.val] = cup
    end

    cmax = maximum(map(c -> c.val, cups))

    current = first(cups)

    for i in 1:rounds
        rem = rem!(current)
        d = dest(current, rem, cmax, addresses)
        ins!(d, rem)
        
        current = current.next
    end
end

function rem!(current)
    x = current.next
    y = x.next
    z = y.next
    current.next = z.next
    return [x, y, z]
end

function dest(current, rem, cmax, addresses)
    used = append!(map(c -> c.val, rem), [current.val])
    i = current.val
    while i in used
        i -= 1
        if i == 0
            i = cmax
        end
    end
    return addresses[i]
end

function ins!(dest, rem)
    tmp = dest.next
    dest.next = first(rem)
    last(rem).next = tmp
end

function val(cups)
    res = ""
    current = first(cups)

    while current.val != 1
        current = current.next
    end
    current = current.next
    while current.val != 1
        res = string(res, current.val)
        current = current.next
    end
    return parse(Int, res)
end

function stars(cups)
    current = first(cups)

    while current.val != 1
        current = current.next
    end
    return current.next.val * current.next.next.val
end

cups = map(n -> Cup(n, nothing), input)
link!(cups)

play!(cups, 100)
p1 = val(cups)

cups = map(n -> Cup(n, nothing), append!(input, collect((maximum(input) + 1):1000000)))
link!(cups)

play!(cups, 10000000)
p2 = stars(cups)

println("-----------------------------------------------------------------------")
println("crab cups -- part one :: $p1")
println("crab cups -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 47598263)
@assert(p2 == 248009574232)