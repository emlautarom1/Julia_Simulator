module address11
@debug "Loading $(@__MODULE__)"

export Size, Space, Value, regadr, flregard, memadr

# Load before allocation
# Attributes
const Size = 0
const Space = 1
const Value = 2
# Space names
const regadr = 0
const flregard = 1
const memadr = 2

end
