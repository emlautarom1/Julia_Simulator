module format11
@debug "Loading $(@__MODULE__)"

export radix, byte, word, long, double, adrcap

# Representation Unit
const radix = 2
# Information Unit
const byte = 8
const word = 16
const long = 32
const double = 64
# Adressing capacity
const adrcap = radix^word

end
