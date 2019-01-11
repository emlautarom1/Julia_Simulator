module name11io

export Ttyinw, Ttyoutw, Ptpinw, Ptpoutw, Clockw, Realtimew, Printerw, Disk256w, Disk64w, Dectapew, Diskcrdw, Tapew

include("./configure11.jl")
using .configure11

# Debug print
println("Running `name11io.jl`...")

const Ttyinw = memcap - 142
const Ttyoutw = memcap - 138
const Ptpinw = memcap - 150
const Ptpoutw = memcap - 146
const Clockw = memcap - 154
const Realtimew = memcap - 160
const Printerw = memcap - 178
const Disk256w = memcap - 210
const Disk64w = memcap - 242
const Dectapew = memcap - 288
const Diskcrdw = memcap - 256
const Tapew = memcap - 176

end