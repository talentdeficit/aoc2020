using DelimitedFiles
using StatsBase

input = joinpath(@__DIR__, "input")
entries = readlines(input)

struct Entry
  low::Int
  high::Int
  char::Char
  pass::String
end

function v1(entry)
  e = parse_entry(entry)
  pass = e.pass
  freq = countmap([c for c in pass])
  if haskey(freq, e.char)
    return freq[e.char] >= e.low && freq[e.char] <= e.high
  end
  return false
end

function v2(entry)
  e = parse_entry(entry)
  pass = e.pass
  return (pass[e.low] == e.char && pass[e.high] != e.char) || (pass[e.low] != e.char && pass[e.high] == e.char)
end

function parse_entry(entry::String)
  parts = split(entry, " ")
  limits = parts[1]
  low = parse(Int, split(limits, "-")[1])
  high = parse(Int, split(limits, "-")[2])
  rule = parts[2]
  char = rule[1]
  pass = parts[3]

  return Entry(low, high, char, pass)
end

p1 = count(v1, entries)
p2 = count(v2, entries)

@assert(p1 == 383)
@assert(p2 == 272)

println("-----------------------------------------------------------------------")
println("password philosophy -- part one :: $p1")
println("password philosophy -- part two :: $p2")
println("-----------------------------------------------------------------------")