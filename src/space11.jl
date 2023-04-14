module space11
@debug "Loading $(@__MODULE__)"

export memory, reg, flreg, ind, flstatus, fle, stop, wait

include("./format11.jl")
include("./configure11.jl")

using .format11, .configure11

# Range from 0.. radix - 1
# Ex: radix = 2 => [0, 1]
_range = 0:(radix - 1)

# System memory
const memory = rand(_range, memcap, byte)
# General registers
const reg = rand(_range, 16, word)
# Floating registers
const flreg = rand(_range, 6, double)
# Indicators
const ind = rand(_range, 10)
# Floating Point status
const flstatus = rand(_range, word)
# Floating Point exceptions
const fle = rand(_range, 4)
# Stop and Wait
const stop = rand(_range)
const wait = rand(_range)
# I/O

end
