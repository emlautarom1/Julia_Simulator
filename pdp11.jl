#------------------------------------------------------------------------------
#--                               pdp-11.jl                                  --
#------------------------------------------------------------------------------
module pdp11
include("./basics.jl")
include("./instruction11.jl") # No dependencies
include("./indicator11.jl") # Calls indicator11io, no dependencies
include("./inst_set11.jl") # No dependencies
include("./address11.jl") # No dependencies
include("./format11.jl") # No dependencies
include("./configure11.jl") # Depends on format11
include("./space11.jl") # Depends on format11, configure11
include("./name11.jl") # Depends on configure11

using
.basics,
.instruction11,
.indicator11,
.inst_set11,
.address11,
.format11,
.configure11,
.space11,
.name11

export form, orop


#-----------------------------------------------------------------------------
#--                             Sintax PDP-11                               --
#-----------------------------------------------------------------------------

const dict = Dict{String,Tuple{String,UnitRange{Int64}}}("Byte" => ("10", 0:0),                                   
     "Source" => ("10", 4:9),                                 
     "OpCode" => ("11", 1:3),                                 
     "Dest" => ("10", 10:15),
     "RSource" => ("10", 7:9),
     "RDest" => ("10", 13:15),
     "Opb" => ("11", 4:6),
     "Opf" => ("11", 4:7),
     "Offset" => ("10", 8:15),
     "Ops" => ("11", 8:9),
     "Cadr" => ("10", 12:15),
     "Ope" => ("11", 13:15),
     "Rfl" => ("10", 8:9))                                    

form = reshape(zeros(Int8, 0), 0, 0, 2)    #init form
form = inPattern(form, "Byte OpCode Source Dest", dict)  
form = inPattern(form, "0 1 1 0 Source Dest", dict) 
form = inPattern(form, "1 1 1 0 Source Dest", dict) 
form = inPattern(form, "0 1 1 1 Opb RSource Dest", dict)  
form = inPattern(form, "0 0 0 0 Opf Offset", dict)  
form = inPattern(form, "1 0 0 0 Opf Offset", dict)  
form = inPattern(form, "1 1 1 1 Opf Rfl Dest", dict)  
form = inPattern(form, "0 0 0 0 1 0 0 RSource Dest", dict)  
form = inPattern(form, "Byte 0 0 0 1 0 1 0 Ops Dest", dict)  
form = inPattern(form, "Byte 0 0 0 1 0 1 1 Ops Dest", dict)  
form = inPattern(form, "Byte 0 0 0 1 1 0 0 Ops Dest", dict)
form = inPattern(form, "0 0 0 0 0 0 0 0 Ops Dest", dict)  
form = inPattern(form, "0 0 0 0 1 1 0 1 Ops Dest", dict)  
form = inPattern(form, "1 1 1 1 0 0 0 0 Ops Dest", dict)  
form = inPattern(form, "1 1 1 1 0 0 0 1 Ops Dest", dict)  
form = inPattern(form, "0 0 0 0 0 0 0 0 1 0 0 0 0 RDest", dict)
form = inPattern(form, "0 0 0 0 0 0 0 0 1 0 0 1 1 RDest", dict)
form = inPattern(form, "0 0 0 0 0 0 0 0 1 0 1 0 Cadr", dict)
form = inPattern(form, "0 0 0 0 0 0 0 0 1 0 1 1 Cadr", dict)
form = inPattern(form, "0 0 0 0 0 0 0 0 0 0 0 0 0 Ope", dict) 
form = inPattern(form, "1 1 1 1 0 0 0 0 0 0 0 0 0 Ope", dict)
form = inPattern(form, "1 1 1 1 0 0 0 0 0 0 0 0 1 Ope", dict)

orop = (2).^reduce(+, reduce(&, form, dims = 3), dims = 2)
orop = [reduce(+, orop[1:i]) for i = 1:length(orop)]
loper = pop!(orop)
pushfirst!(orop, 0)
orop = orop .+ 1

#-----------------------------------------------------------------------------
#--                             Addressing PDP-11                           --
#-----------------------------------------------------------------------------

function read11(address)
    local size = address[Size]
    local switch = address[Space]

    # local data
    if switch == 0
        # Register

        # local location = regmap11(address[Value])
        # local data = (reg[location,:])[1:min(-size, word)]
    else
        if switch == 1
        # Floating Point Register

            data = flreg[(address[Value] % 6) , 1:size]
            # Se toman size bits del registro de pf especificado en Value

            # flinvop report11fl address[Value] ≥ 6
        else
            # Memory
            
            local location = address[Value] + adrperm11(size)
           
            # adrcheck11(location)
            # Verificacion de ubicacion valida

            data =  memory[(location % memcap),:]
            # Se recuperan los bits de la memoria especificados en location, con modulo memcap.
        end
    end
    # return data
end

function write11(address, data)
    local size = address[Size]
    local switch = address[Space]

    if switch == 0
        # Write en registro

        # local location = regmap11(address[Value])
        # reg[location;word[end - size:end]] = data

        # Se escriben word bits en el registro indicado 
        # En caso de que size sea menor que word, se escriben los ultimos size bits de data
    elseif switch == 1
        # Write en registro pf

        # flinvop report11fl address[Value] >= 6
        # →OUT address[Value]≥6
        flreg[address[Value], 1:size] = data

        # Se escriben los size bits en el registro indicado
    else
        # Write en memoria

        local location = address[Value] + adrperm11(size)
        # adrcheck(location)
        # →OUT suppress11
        memory[location,:] = wide(byte, data)
        # TODO(lautaroem1): Function supress11?
    end
end

function adrperm11(size)
    local loc = collect(1:div(size, byte))
    # perm← (⍴loc)↑,⌽2 wide loc
end

#-----------------------------------------------------------------------------
#--                             Address modification                        --
#-----------------------------------------------------------------------------

function adr11(size, field)
    local r = fld(field[R])
    local step = r in [Sp, Pc] ? word : size
    local case = fld(field[M])
    
    # local address
    if case == 0
        # Register

        # address = vcat(size, regadr, r)
    elseif case == 1
        # Indirect register

        local rf = magni(read11(vcat(word, regadr, r)))
        address = vcat(size, memadr, rf)
    elseif case == 2
        # Postincrement

        # address = size,1↓ step incr11 r
    elseif case == 3
        # Indirect Postincrement

        # rf← magni read11 word incr11 r
        # address = vcat(size, memadr, rf)
    elseif case == 4
        # Predecrement

        # address = size,1↓ step decr11 r
    elseif case == 5
        # Indirect Predecrement
        # rf = magni read11 word decr11 r
        # address = vcat(size, memadr, rf)
    elseif case == 6
        # Index + Displacement
        
        # address= size disp11 r
    else
        # Indirect Index + Displacement
        
        # rf = magni read11 word disp11 r
        # address = vcat(size, memadr, rf)
    end
    # return address
end

end #module pdp11