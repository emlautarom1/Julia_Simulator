module indicator11

include("./indicator11io.jl")

export Warning, Spec, Invop, Bpt, Iot, Powerfail, Emt, Trap, Pir, Fle

# Debug print
println("Running `indicator11.jl`...")

# Program
const Warning = 0
const Spec = 1
const Invop = 2
# Breakpoint
const Bpt = 3
# I/O
const Iot = 4
# Powerfail
const Powerfail = 5
# Emulator
const Emt = 6
# General trap
const Trap = 7
# Programmed interrupt
const Pir = 40
# Floating Point exception
const Fle = 41
# idicator11io
using .indicator11io

end