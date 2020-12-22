input = joinpath(@__DIR__, "input")
eqs = readlines(input)

EQ = r"(\d+)|([+])|([*])|([(])|([)])"

function parse_eqs(eqs)
    acc = []
    for eq in eqs
        matches = eachmatch(EQ, eq)
        r = map(m -> only(filter(!isnothing, m.captures)), matches)
        push!(acc, r)
    end
    return acc
end

function convert(eqs, prec)::Vector{Vector{String}}
    acc = []
    for eq in eqs
        res = postfix(eq, prec)
        push!(acc, res)
    end
    return acc
end

function postfix(eq, prec)
    postfix = []
    operators = []
    for symbol in eq
        if symbol in ["+", "*"]
            if !isempty(operators) && last(operators) in ["+", "*"] && prec[symbol] <= prec[last(operators)]
                push!(postfix, pop!(operators))
                push!(operators, symbol)
            else
                push!(operators, symbol)
            end
        elseif symbol == "("
            push!(operators, symbol)
        elseif symbol == ")"
            while (op = pop!(operators); op != "(")
                push!(postfix, op)
            end
        else
            push!(postfix, symbol)
        end
    end
    while !isempty(operators)
        op = pop!(operators)
        push!(postfix, op)
    end
    return postfix
end

function evaluate(eqs::Vector{Vector{String}})
    return map(eq -> evaluate(eq), eqs)
end

function evaluate(eq::Vector{String})
    stack = []
    for symbol in eq
        if symbol == "+"
            left = pop!(stack)
            right = pop!(stack)
            push!(stack, left + right)
        elseif symbol == "*"
            left = pop!(stack)
            right = pop!(stack)
            push!(stack, left * right)
        else
            push!(stack, parse(Int, symbol))
        end
    end
    return only(stack)
end

eqs = filter(!isempty, eqs)
eqs = parse_eqs(eqs)

p1 = sum(evaluate(convert(eqs, Dict("+" => 1, "*" => 1))))
p2 = sum(evaluate(convert(eqs, Dict("+" => 2, "*" => 1))))

println("-----------------------------------------------------------------------")
println("operation order -- part one :: $p1")
println("operation order -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 21993583522852)
@assert(p2 == 122438593522757)