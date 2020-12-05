input = joinpath(@__DIR__, "input")
entries = readlines(input)

req = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

function completed(passport)
  ks = keys(passport)
  issubset(req, ks)
end

function validated(passport)
  byr = parse(Int, passport["byr"])
  iyr = parse(Int, passport["iyr"])
  eyr = parse(Int, passport["eyr"])
  hgt = passport["hgt"]
  hcl = passport["hcl"]
  ecl = passport["ecl"]
  pid = passport["pid"]
  if (1920 > byr) || (byr > 2002) ||
     (2010 > iyr) || (iyr > 2020) ||
     (2020 > eyr) || (eyr > 2030) ||
     !occursin(r"^(1[5-8][0-9]|19[0-3])(cm)$|^(59|6[0-9]|7[0-6])(in)$", hgt) ||
     !occursin(r"^#([0-9]|[a-f]){6}$", hcl) ||
     !(ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]) ||
     !occursin(r"^[0-9]{9}$", pid)
    return false
  end

  return true
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

println("-----------------------------------------------------------------------")
println("passport processing -- part one :: $p1")
println("passport processing -- part two :: $p2")
println("-----------------------------------------------------------------------")