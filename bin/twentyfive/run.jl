CARDPK = 1526110
DOORPK = 20175123

SUBJECT = 7
SALT = 20201227

function find_loop_size(pk, subject)
    i = 0
    n = 1
    while n != pk
        i += 1
        n *= subject
        n = mod(n, SALT)
    end
    return i
end

function enc(subject, loops)
    n = 1
    for _ in 1:loops
        n *= subject
        n = mod(n, SALT)
    end
    return n
end

card = find_loop_size(CARDPK, SUBJECT)
door = find_loop_size(DOORPK, SUBJECT)
p1 = enc(DOORPK, card)

println("-----------------------------------------------------------------------")
println("combo breaker -- part one :: $p1")
println("-----------------------------------------------------------------------")

@assert(p1 == 10924063)