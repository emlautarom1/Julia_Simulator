
To test it:

    julia include("pdp11.jl")

Example:

    pdp11.basics.decode(vec(Int8[1 1 0 1 0 1 0 1 1 1 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop)

Should return BIS function
