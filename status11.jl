module status11

export Currentmode, Previousmode, Regset, Priority, Trace, Neg, Zero, Oflo, Carry, Kernel, Supervisor, User

# Debug print
println("Running `status11.jl`...")

# Mode control
const Currentmode = [1, 2]
const Previousmode = [3, 4] 
# Register set
const Regset = 4
# Interrupt priority
const Priority = [9, 10, 11]
# Trace mode
const Trace = 11
# Conditions
const Neg = 12
const Zero = 13
const Oflo = 14
const Carry = 15
# Mode codification
const Kernel = 0
const Supervisor = 1
const User = 2   

end