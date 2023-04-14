module status11fl
@debug "Loading $(@__MODULE__)"

export Fer, Fid, Fiuv, Fiu, Fiv, Fic, Fd, Fl, Ft, Neg, Zero, Oflo, Carry, flinvop, fldivide, floflo, fluflo, flundef, flmaint

# Floating point error DEC PDP-11
# Error
const Fer =  0
# Interrup disable
const Fid =  1
# Undefined variable
const Fiuv =  4
# Underflow
const Fiu =  5
# Overflow
const Fiv =  6
# Conversion error
const Fic =  7
# Double mode
const Fd =  8
# Long integer mode
const Fl =  9
# Truncation mode
const Ft =  10
# Conditions
const Neg =  12
const Zero =  13
const Oflo =  14
const Carry =  15
# Error codes
const flinvop =  2
const fldivide =  4
const flconverr =  6
const floflo =  8
const fluflo =  10
const flundef =  12
const flmaint =  14

end
