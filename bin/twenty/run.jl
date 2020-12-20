using Test

input = joinpath(@__DIR__, "input")
tiles = map(t -> split(t, "\n"), split(read(input, String), "\n\n"))

mutable struct Tile
    id::Int
    raw::Array{Char, 2}
end

function copy(tile::Tile)
    new = copy(tile.raw)
    return Tile(tile.id, new)
end

t = Tile(1, ['a' 'b' 'c'; 'd' 'e' 'f'])

function size(tile::Tile)
    return Base.size(tile.raw)
end

@test size(t) == (2, 3)

function top(tile::Tile)
    (y, x) = size(tile)
    return tile.raw[range(1, length=x, step=y)]
end

@test top(t) == ['a', 'b', 'c']

function right(tile::Tile)
    (y, x) = size(tile)
    return tile.raw[range((x * y) - y + 1, length=y, step=1)]
end

@test right(t) == ['c', 'f']

function bottom(tile::Tile)
    (y, x) = size(tile)
    return tile.raw[range(y, length=x, step=y)]
end

@test bottom(t) == ['d', 'e', 'f']

function left(tile::Tile)
    (y, x) = size(tile)
    return tile.raw[range(1, length=y, step=1)]
end

@test left(t) == ['a', 'd']

function flip!(tile)
    new = tile.raw[:,end:-1:1]
    tile.raw = new
end

function rotate!(tile)
    new = rotr90(tile.raw)
    tile.raw = new
end

function parse_tiles(tiles)
    return map(tile -> parse_tile(tile), tiles)
end

function parse_tile(tile)
    m = match(r"(\d+)", first(tile))
    id = parse(Int, m.captures[1]) 
    raw = reduce(vcat, permutedims.(collect.(tile[2:end])))
    return Tile(id, raw)
end

function find_edges(tile)
    edges = []
    push!(edges, top(tile))
    push!(edges, right(tile))
    push!(edges, bottom(tile))
    push!(edges, left(tile))
    push!(edges, reverse(top(tile)))
    push!(edges, reverse(right(tile)))
    push!(edges, reverse(bottom(tile)))
    push!(edges, reverse(left(tile)))
    return edges
end

function orient!(tile, matches)
    for flipped in (false, true), i in 1:4
        matches(tile) && return
        flipped && flip!(tile)
        flipped && matches(tile) && return
        flipped && flip!(tile)
        rotate!(tile)
    end
end

function find_corners(tiles)
    corners = []
    ec = count_edges(tiles)

    for tile in tiles
        c = sum([length(ec[top(tile)]), length(ec[bottom(tile)]), length(ec[left(tile)]), length(ec[right(tile)])])
        c == 6 && push!(corners, tile)
    end
    return corners
end

function count_edges(tiles)
    acc = Dict{Vector{Char}, Vector{Int}}()
    for tile in tiles
        edges = find_edges(tile)
        for edge in edges
            haskey(acc, edge) ? acc[edge] = append!(acc[edge], tile.id) : acc[edge] = [tile.id]
        end
    end
    return acc
end

function find_origin(tiles)
    edges = count_edges(tiles)
    corner = first(find_corners(tiles))
    for _ in 1:4
        t = edges[top(corner)]
        l = edges[left(corner)]
        length(t) == 1 && length(l) == 1 && return corner
        rotate!(corner)
    end
end

function trim(tile)
    raw = tile.raw
    (x, y) = size(tile)
    return raw[2:(x - 1),2:(y - 1)]
end

function assemble(tiles)
    origin = find_origin(deepcopy(tiles))
    edges = count_edges(deepcopy(tiles))

    rows = []
    row = [origin]

    rowstart = origin
    current = origin

    while !isnothing(current)
        match = edges[right(current)]
        if length(match) == 2
            next_id = only(filter(id -> id != current.id, match))
            next_idx = findfirst(t -> t.id == next_id, tiles)
            next = tiles[next_idx]
            matcher = (t) -> left(t) == right(current)
            orient!(next, matcher)
            push!(row, next)
            current = next
        else
            push!(rows, row)
            match = edges[bottom(rowstart)]
            if length(match) == 2
                next_id = only(filter(id -> id != rowstart.id, match))
                next_idx = findfirst(t -> t.id == next_id, tiles)
                next = tiles[next_idx]
                orient!(next, (t) -> top(t) == bottom(rowstart))
                current = next
                rowstart = current
                row = [rowstart]
            else
                current = nothing
            end
        end
    end

    return vcat(map(row -> hcat(map(tile -> trim(tile), row)...), rows)...)
end

function find_seamonsters(assembled)
    # seamonster pattern
    indices = [
        CartesianIndex(19, 1),
        CartesianIndex(1, 2),
        CartesianIndex(6, 2),
        CartesianIndex(7, 2),
        CartesianIndex(12, 2),
        CartesianIndex(13, 2),
        CartesianIndex(18, 2),
        CartesianIndex(19, 2),
        CartesianIndex(20, 2),
        CartesianIndex(2, 3),
        CartesianIndex(5, 3),
        CartesianIndex(8, 3),
        CartesianIndex(11, 3),
        CartesianIndex(14, 3),
        CartesianIndex(17, 3)
    ]

    (xr, yr) = Base.size(assembled) .- (20, 3)

    counts = []

    for flipped in (false, true), i in 1:4
        flipped ? assembled = assembled[end:-1:1,:] : nothing
        count = 0
        idx = CartesianIndex(0,0)
        for j in 1:yr
            (x, y) = Tuple(idx)
            idx = CartesianIndex(0, y + 1)
            for i in 1:xr
                idx += CartesianIndex(1, 0)
                all(i -> assembled[idx + i] == '#', indices) ? count += 1 : nothing
            end
        end
        push!(counts, count)
        flipped ? assembled = assembled[end:-1:1,:] : nothing
        assembled = rotr90(assembled)
    end
    return counts
end

function check(puzzle)
    acc = 0
    for i in eachindex(puzzle)
        puzzle[i] == '#' ? acc += 1 : nothing
    end
    return acc
end

tiles = parse_tiles(tiles)
corners = find_corners(tiles)

assembled = assemble(tiles)
counts = find_seamonsters(assembled)

p1 = prod(map(tile -> tile.id, corners))
p2 = check(assembled) - (maximum(counts) * 15)

println("-----------------------------------------------------------------------")
println("jurassic jigsaw -- part one :: $p1")
println("jurassic jigsaw -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 174206308298779)
@assert(p2 == 2409)