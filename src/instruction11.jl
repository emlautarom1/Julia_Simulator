module instruction11

export Byte, Source, Opcode, Dest, Rfl, Cadr, Opb, Opf, Offset, Ops, Ope, M, R

# Debug print
println("Running `instruction11.jl`...")

# Size specification
const Byte = 0:0

# Operation specification
const Source = 4:9

# Operand specification
const Opcode = 1:3
const Dest = 10:15
const Rfl = 8:9
const Cadr = 12:15

# Register operations and bifurcations
const Opb = 4:6
const Opf = 4:7
const Offset = 8:15

# Unary operations
const Ops = 8:9

# Operation code extension
const Ope = 13:15

# Addres field suballocation
# Mode
const M = 1:3
# Register
const R = 4:6

end