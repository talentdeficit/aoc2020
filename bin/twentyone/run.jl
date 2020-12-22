input = joinpath(@__DIR__, "input")
foods = readlines(input)

function parse_contents(foods)
    acc = []
    for food in foods
        (recipes, allergens) = split(food, " (contains ")
        recipes = map(s -> strip(s), split(recipes, " "))
        allergens = map(s -> strip(s), split(allergens[1:end - 1], ","))
        push!(acc, (recipes, allergens))
    end
    return acc
end

function tainted(foods)
    acc = Dict{String, Vector{String}}()
    for (recipe, allergens) in foods
        for allergen in allergens
            if haskey(acc, allergen)
                as = acc[allergen]
                acc[allergen] = intersect(as, recipe)
            else
                acc[allergen] = recipe
            end
        end
    end
    return acc
end

function all_ingredients(foods)
    acc = Set{String}()
    for (recipe, _) in foods
        for ingredient in recipe
            push!(acc, ingredient)
        end
    end
    return acc
end

function all_tainted_ingredients(tainted)
    acc = Set{String}()
    for (_, ingredients) in tainted
        for ingredient in ingredients
            push!(acc, ingredient)
        end
    end
    return acc
end

function count_okay(dishes, okay)
    count = 0
    for (ingredients, _) in dishes
        for ingredient in ingredients
            if ingredient in okay
                count += 1
            end
        end
    end
    return count
end

function solve(tainted)
    result = Dict{String, String}()
    seen = []

    while length(result) < length(tainted)
        for (k, v) in tainted
            left = setdiff(v, seen)
            if length(left) == 1
                append!(seen, left)
                result[k] = left[1]
            end
        end
    end

    return result
end

dishes = parse_contents(foods)
t = tainted(dishes)
a = all_ingredients(dishes)
at = all_tainted_ingredients(t)
okay = setdiff(a, at)

solved = solve(t)
solved = collect(solved)
sort!(solved, by=(kv -> first(kv)))

p1 = count_okay(dishes, okay)
p2 = join([v for (_, v) in solved], ",")

println("-----------------------------------------------------------------------")
println("allergen assessment -- part one :: $p1")
println("allergen assessment -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 2203)
@assert(p2 == "fqfm,kxjttzg,ldm,mnzbc,zjmdst,ndvrq,fkjmz,kjkrm")