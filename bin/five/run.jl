input = joinpath(@__DIR__, "input")
passes = readlines(input)

function seat(pass)
  pass = replace(pass, r"F|L" => "0")
  pass = replace(pass, r"B|R" => "1")
  row = parse(Int, pass[1:7], base=2)
  col = parse(Int, pass[8:end], base=2)
  return row * 8 + col
end

function findseat(seatids)
  allpossible = collect(minimum(seatids):maximum(seatids))
  myseat = first(filter(i -> !(i in seatids), allpossible))
  return myseat
end

seatids = map(p -> seat(p), passes)
sorted = sort(seatids)

p1 = maximum(seatids)
p2 = findseat(sorted)

println("-----------------------------------------------------------------------")
println("binary boarding -- part one :: $p1")
println("binary boarding -- part two :: $p2")
println("-----------------------------------------------------------------------")
