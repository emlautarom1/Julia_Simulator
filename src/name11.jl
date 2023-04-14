module name11
@debug "Loading $(@__MODULE__)"

export Psw, Slw, Piw, Intvec, Sp, Pc

include("./configure11.jl")
include("./name11io.jl")
using .configure11

# Memory embedding
# Program status
const Psw = memcap - 2
# Stack limit
const Slw = memcap - 4
# Programmed interrupt
const Piw = memcap - 6
# Interrupt vector
const Intvec = [x * 4 for x in 1:43]

# Register names
# Stack pointer
const Sp = 6
# Instruction address
const Pc = 7
# IO devices
# Run name11io
using .name11io

end
