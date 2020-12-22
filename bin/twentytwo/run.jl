input = joinpath(@__DIR__, "input")
input = read(input, String)

input = split(input, "\n\n")

one = input[1]
two = input[2]

CARDS = r"(\d+)"

one = map(m -> parse(Int, m.captures[1]), collect(eachmatch(CARDS, one)))
two = map(m -> parse(Int, m.captures[1]), collect(eachmatch(CARDS, two)))

# remove player number from matches
one = one[2:end]
two = two[2:end]

function play(one, two)
    while length(one) > 0 && length(two) > 0
        x = popfirst!(one)
        y = popfirst!(two)
        if x > y
            push!(one, x, y)
        else
            push!(two, y, x)
        end
    end
    if length(one) > length(two)
        return (one, nothing)
    else
        return (nothing, two)
    end
end

function playr(one, two)
    seen = Set{}()
    while length(one) > 0 && length(two) > 0
        if (one, two) in seen
            return (one, nothing)
        end
        push!(seen, (copy(one), copy(two)))
        x = popfirst!(one)
        y = popfirst!(two)
        if x <= length(one) && y <= length(two)
            result = playr(copy(one[1:x]), copy(two[1:y]))
            if isnothing(result[1])
                push!(two, y, x)
            else
                push!(one, x, y)
            end
        elseif x > y
            push!(one, x, y)
        else
            push!(two, y, x)
        end
    end
    if length(one) > length(two)
        return (one, nothing)
    else
        return (nothing, two)
    end
end

function score(deck)
    reverse!(deck)
    sum = 0
    for i in 1:length(deck)
        sum += i * deck[i]
    end
    return sum
end

result = play(copy(one), copy(two))
winner = isnothing(result[1]) ? result[2] : result[1]
p1 = score(winner)

result = playr(copy(one), copy(two))
winner = isnothing(result[1]) ? result[2] : result[1]
p2 = score(winner)

println("-----------------------------------------------------------------------")
println("crab combat -- part one :: $p1")
println("crab combat -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 32448)
@assert(p2 == 32949)