input = joinpath(@__DIR__, "input")
tiles = map(t -> split(t, "\n"), split(read(input, String), "\n\n"))

mutable struct Tile
    id::Int
    raw::Array{Char, 2}
    top::Vector{Char}
    bottom::Vector{Char}
    left::Vector{Char}
    right::Vector{Char}
    coord::Union{Nothing, Pair{Int, Int}}
end

function copy(tile::Tile)
    return Tile(tile.id, tile.raw, tile.top, tile.bottom, tile.left, tile.right, nothing)
end

function parse_tiles(tiles)
    return map(tile -> parse_tile(tile), tiles)
end

function parse_tile(tile)
    m = match(r"(\d+)", first(tile))
    id = parse(Int, m.captures[1]) 
    map = reduce(vcat, permutedims.(collect.(tile[2:end])))
    map = reshape(map, (10, 10))
    (left, right, top, bottom) = find_edges(map)
    return Tile(id, map, top, bottom, left, right, nothing)
end

function find_edges(tile)
    (xm, ym) = size(tile)
    left = tile[1:xm]
    right = tile[(length(tile) - xm + 1):(length(tile))]
    top = tile[range(1, length=10, step=10)]
    bottom = tile[range(10, length=10, step=10)]
    return (left, right, top, bottom)
end

function flipx!(tile)
    new = tile.raw[:,end:-1:1]
    (left, right, top, bottom) = find_edges(new)
    tile.raw = new
    tile.top = top
    tile.bottom = bottom
    tile.left = left
    tile.right = right
end

function flipy!(tile)
    new = tile.raw[end:-1:1,:]
    (left, right, top, bottom) = find_edges(new)
    tile.raw = new
    tile.top = top
    tile.bottom = bottom
    tile.left = left
    tile.right = right
end

function rotate!(tile)
    new = rotr90(tile.raw)
    (left, right, top, bottom) = find_edges(new)
    tile.raw = new
    tile.top = top
    tile.bottom = bottom
    tile.left = left
    tile.right = right
end

function reorientr!(tile, edge)
    tile.left == edge && return
    rotate!(tile)
    tile.left == edge && return
    rotate!(tile)
    tile.left == edge && return
    rotate!(tile)
    tile.left == edge && return
    flipx!(tile)
    tile.left == edge && return
    rotate!(tile)
    tile.left == edge && return
    rotate!(tile)
    tile.left == edge && return
    rotate!(tile)
    tile.left == edge && return
end

function reorientb!(tile, edge)
    tile.top == edge && return
    rotate!(tile)
    tile.top == edge && return
    rotate!(tile)
    tile.top == edge && return
    rotate!(tile)
    tile.top == edge && return
    flipx!(tile)
    tile.top == edge && return
    rotate!(tile)
    tile.top == edge && return
    rotate!(tile)
    tile.top == edge && return
    rotate!(tile)
    tile.top == edge && return
end

function find_corners(tiles)
    corners = []
    ec = count_edges(tiles)

    for tile in tiles
        c = sum([length(ec[tile.top]), length(ec[tile.bottom]), length(ec[tile.left]), length(ec[tile.right])])
        c == 6 && push!(corners, tile)
    end
    return corners
end

function count_edges(tiles)
    acc = Dict{Vector{Char}, Vector{Int}}()
    for tile in tiles
        haskey(acc, tile.top) ? acc[tile.top] = append!(acc[tile.top], tile.id) : acc[tile.top] = [tile.id]
        haskey(acc, tile.bottom) ? acc[tile.bottom] = append!(acc[tile.bottom], tile.id) : acc[tile.bottom] = [tile.id]
        haskey(acc, tile.left) ? acc[tile.left] = append!(acc[tile.left], tile.id) : acc[tile.left] = [tile.id]
        haskey(acc, tile.right) ? acc[tile.right] = append!(acc[tile.right], tile.id) : acc[tile.right] = [tile.id]
        flipx!(tile)
        haskey(acc, tile.top) ? acc[tile.top] = append!(acc[tile.top], tile.id) : acc[tile.top] = [tile.id]
        haskey(acc, tile.bottom) ? acc[tile.bottom] = append!(acc[tile.bottom], tile.id) : acc[tile.bottom] = [tile.id]
        flipy!(tile)
        haskey(acc, tile.left) ? acc[tile.left] = append!(acc[tile.left], tile.id) : acc[tile.left] = [tile.id]
        haskey(acc, tile.right) ? acc[tile.right] = append!(acc[tile.right], tile.id) : acc[tile.right] = [tile.id]
    end
    return acc
end

function find_origin(tiles)
    edges = count_edges(tiles)
    corners = find_corners(tiles)
    for corner in corners
        top = edges[corner.top]
        left = edges[corner.left]
        length(top) == 1 && length(left) == 1 && return corner
    end
end

function find_next(edge, tiles)
    for tile in tiles
        edge == tile.top && return tile
        rotate!(tile)
        edge == tile.top && return tile
        rotate!(tile)
        edge == tile.top && return tile
        rotate!(tile)
        edge == tile.top && return tile
        flipx!(tile)
        rotate!(tile)
        edge == tile.top && return tile
        rotate!(tile)
        edge == tile.top && return tile
        rotate!(tile)
        edge == tile.top && return tile
        rotate!(tile)
        edge == tile.top && return tile
    end
end

function trim(tile)
    raw = tile.raw
    (x, y) = size(raw)
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
        match = edges[current.right]
        if length(match) == 2
            next_id = only(filter(id -> id != current.id, match))
            next_idx = findfirst(t -> t.id == next_id, tiles)
            next = tiles[next_idx]
            reorientr!(next, current.right)
            push!(row, next)
            current = next
        else
            push!(rows, row)
            match = edges[rowstart.bottom]
            if length(match) == 2
                next_id = only(filter(id -> id != rowstart.id, match))
                next_idx = findfirst(t -> t.id == next_id, tiles)
                next = tiles[next_idx]
                reorientb!(next, rowstart.bottom)
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



    count = 0
    idx = CartesianIndex(0,0)
    for j in 1:93
        (x, y) = Tuple(idx)
        idx = CartesianIndex(0, y + 1)
        for i in 1:76
            idx += CartesianIndex(1, 0)
            all(i -> assembled[idx + i] == '#', indices) ? count += 1 : nothing
        end
    end
    return count
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

puzzle = assembled
a = find_seamonsters(puzzle)
puzzle = rotr90(puzzle)
b = find_seamonsters(puzzle)
puzzle = rotr90(puzzle)
c = find_seamonsters(puzzle)
puzzle = rotr90(puzzle)
d = find_seamonsters(puzzle)

puzzle = puzzle[end:-1:1,:]

e = find_seamonsters(puzzle)
puzzle = rotr90(puzzle)
f = find_seamonsters(puzzle)
puzzle = rotr90(puzzle)
g = find_seamonsters(puzzle)
puzzle = rotr90(puzzle)
h = find_seamonsters(puzzle)

p1 = prod(map(tile -> tile.id, corners))
p2 = check(assembled) - (maximum([a,b,c,d,e,f,g,h]) * 15)



println("-----------------------------------------------------------------------")
println("jurassic jigsaw -- part one :: $p1")
println("jurassic jigsaw -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 174206308298779)
@assert(p2 == 2409)