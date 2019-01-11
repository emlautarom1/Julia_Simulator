module indicator11io

export Ttyin, Ttyout, Ptpin, Ptpout, Clock, Realtime, Printer, Disk256, Disk64, Dectape, Diskcrd, Tape

# Debug print
println("Running `indicator11.jl`...")

const Ttyin = 12
const Ttyout = 13
const Ptpin = 14
const Ptpout = 15
const Clock = 16
const Realtime = 17
const Printer = 32
const Disk256 = 33
const Disk64 = 34
const Dectape = 35
const Diskcrd = 36
const Tape = 37

end