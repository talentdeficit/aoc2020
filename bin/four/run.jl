input = joinpath(@__DIR__, "input")
entries = readlines(input)

req = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

validators = Dict(
  "byr" => v -> begin byr = parse(Int, v); 1920 <= byr && byr <= 2002 end,
  "iyr" => v -> begin iyr = parse(Int, v); 2010 <= iyr && iyr <= 2020 end,
  "eyr" => v -> begin eyr = parse(Int, v); 2020 <= eyr && eyr <= 2030 end,
  "hgt" => v -> occursin(r"^(1[5-8][0-9]|19[0-3])(cm)$|^(59|6[0-9]|7[0-6])(in)$", v),
  "hcl" => v -> occursin(r"^#([0-9]|[a-f]){6}$", v),
  "ecl" => v -> (v in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]),
  "pid" => v -> occursin(r"^[0-9]{9}$", v),
  "cid" => v -> true
)

function completed(passport)
  ks = keys(passport)
  issubset(req, ks)
end

function validated(passport)
  ks = collect(keys(passport))
  !(false in map(k -> validators[k](passport[k]), ks))
end

function col(entries)
  acc = []
  curr = []
  for entry in entries
    if entry == ""
      push!(acc, Dict(curr))
      curr = []
    else
      kvs = split(entry, " ")
      attrs = (split(ks, ":") for ks in kvs)
      append!(curr, attrs)
    end
  end

  if !isempty(curr)
    push!(acc, Dict(curr))
  end

  return acc
end

passports = col(entries)
presentable = filter(p -> completed(p), passports)
valid = filter(p -> validated(p), presentable)

p1 = length(presentable)
p2 = length(valid)

@assert(p1 == 213)
@assert(p2 == 147)

println("-----------------------------------------------------------------------")
println("passport processing -- part one :: $p1")
println("passport processing -- part two :: $p2")
println("-----------------------------------------------------------------------")