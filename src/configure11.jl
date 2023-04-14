module configure11
@debug "Loading $(@__MODULE__)"

export memcap

include("./format11.jl")
using .format11

const memcap = radix^word

end
