module configure11
export memcap

include("./format11.jl")
using .format11

# Debug print
println("Running `configure11.jl`...")

const memcap = radix^word

end