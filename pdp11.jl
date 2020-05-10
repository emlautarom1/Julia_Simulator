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
include("./status11.jl") # No dependencies
include("./status11fl.jl") # No dependencies
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
.status11,
.status11fl,
.configure11,
.space11,
.name11

export form, orop




#-----------------------------------------------------------------------------
#--                             Addressing PDP-11                           --
#-----------------------------------------------------------------------------

function read11(address)
    local size = address[Size]
    local switch = address[Space]

    local data
    if switch == 0
        # Register

        local location = regmap11(address[Value])
        local data = (reg[location,:])[1:min(-size, word)]
    else
        if switch == 1
        # Floating Point Register

            data = flreg[(address[Value] % 6) , 1:size]
            # Se toman size bits del registro de pf especificado en Value

            report11fl(flinvop, address[Value] >= 6)
        else
            # Memory
            
            local location = address[Value] + adrperm11(size)
           
            adrcheck11(location)
            # Verificacion de ubicacion valida

            data =  memory[(location % memcap),:]
            # Se recuperan los bits de la memoria especificados en location, con modulo memcap.
        end
    end
    return data
end

function write11(address, data)
    local size = address[Size]
    local switch = address[Space]

    if switch == 0
        # Write en registro

        # Se escriben word bits en el registro indicado 
        # En caso de que size sea menor que word, se escriben los ultimos size bits de data

        local location = regmap11(address[Value])
        reg[location, word[end - size:end]] = data
    elseif switch == 1
        # Write en registro pf

        report11fl(flinvop, address[Value] >= 6)

        # address[Value] >= 6
        # →OUT address[Value]≥6

        flreg[address[Value], 1:size] = data
        # Se escriben los size bits en el registro indicado
    else
        # Write en memoria

        local location = address[Value] + adrperm11(size)
        adrcheck11(location)
        suppress11()
        memory[location,:] = wide(byte, data)
    end
end

function adrperm11(size)
    local loc = collect(1:div(size, byte))
    return reverse(wide(2, loc))[1:length(loc)]
end

#-----------------------------------------------------------------------------
#--                             Address modification                        --
#-----------------------------------------------------------------------------

function adr11(size, field)
    local r = fld(field[R])
    local step = r in [Sp, Pc] ? word : size
    local case = fld(field[M])
    
    local address
    if case == 0
        # Register

        address = [size regadr r]
    elseif case == 1
        # Indirect register

        local rf = magni(read11([word regadr r]))
        address = [size memadr rf]
    elseif case == 2
        # Postincrement

        address = [size incr11(step, r)[2:end]]
    elseif case == 3
        # Indirect Postincrement
        
        local rf = magni(read11(incr11(word, r))) 
        address = [size memadr rf]
    elseif case == 4
        # Predecrement
        
        address = [size decr11(step, r)[2:end]]
    elseif case == 5
        # Indirect Predecrement

        local rf = magni(read11(decr11(word, r)))
        address = [size memadr rf]
    elseif case == 6
        # Index + Displacement
        
        address = disp11(size, r)
    else
        # Indirect Index + Displacement
        
        local rf = magni(read11(disp11(word, r)))
        address = [size memadr rf]
    end
    return address
end

function adr11fl(size, field)
    local r = fld(field[R])
    local step = r == Pc ? word : size
    local switch = fld(field[R])

    local address
    if switch == 0
        # Register

        address = [size flregard r]
    elseif switch == 1
        # Indirect register
        
        local rf = read11([word regadr r])
        address = [size memadr rf]
    elseif switch == 2
        # Postincrement

        address = incr11(step, r)
    elseif switch == 3
        # Indirect postincrement

        local rf = magni(read11(incr11(word, r)))
        address = [size memadr rf]
    elseif switch == 4
        # Predecrement

        address = decr11(step, r)
    elseif switch == 5
        # Indirect predecrement

        local rf = magni(read11(decr11(word, r)))
        address = [size memadr rf]
    elseif switch == 6
        # Index + displacement

        address = disp11(size, r)
    else
        # Indirect index + displacement

        local rf = magni(read11(disp11(word, r)))
        address = [size memadr rf]
    end
    return address
end

function disp11(size, r)
    local displacement = magni(ifetch11())
    local index = magni(regout(r))
    return [size memadr (index + displacement % adrcap)]
end

function incr11(size, r)
    # DEC PDP11 postincrement
    
    local address = [size memadr magni(regout(r))]
    local count = address[Value] + (size / byte)
    regin(r, magnr(word, count))
    return address
end

function decr11(size, r)

    local count = magni(regout(r)) - (size / byte)
    # report(Warning, (r==Sp && count == limit11))
    # report(Spec, (r==Sp && count == limit11 - 16))
    local address = [size memadr (count % adrcap)]
    regin(r, magnr(word, address[Value]))
    return address
end

function limit11()
    # DEC PDP11 stack limit
    if Kernel == magni(stout(Currentmode))
        return magni(read11([word memadr Slw]))
    else
        return 256
    end
end

function regin(adr, data)
    # DEC PDP11 register input

    return reg[regmap11(adr),:] = data
end

function regout(adr)
    return reg[regmap11(adr),:]
end
    
function od11(adr)
    return !isodd(adr) ? adr + 1 : adr
end

function regmap11(adr)
    # DEC PDP11 register addresses

    local switch = Nothing
    if switch == 0
        # Register set

        return stout(Regset)
    elseif switch == 1
        # Stack pointer

        return Sp + (0, 8, 9)[magni(stout(Currentmode))]
    else
        # Instruction address

        return Pc
    end
end


#--------------------------------------
#--          Status Format           --
#--------------------------------------

function stout(id)
    local psw = read11([word memadr Psw])
    return psw[id]
end

function stin(id, status)
    local psw = read11([word memadr Psw])
    psw[id] = status
    write11([word memadr Psw], psw)
end

#--------------------------------------
#--        Size specification        --
#--------------------------------------

function size11()
    return (word, byte)[fld(Byte)]
end

function size11fl()
    return (long, double)[flstatus[Fd]]
end

#--------------------------------------
#--          Index arithmetic        --
#--------------------------------------

function pop11()
    return read11(incr11(word, Sp))
end

function push11(data)
    # DEC PDP11 write onto stack
    throw("Not implemented!")

    # (word decr11 Sp) write data
end

#--------------------------------------
#--     Integer Domain Signaling     --
#--------------------------------------

function signal11NZ(res)
    stin(Neg, res[1])
    stin(Zero, all(x->x == 0, res))
    stin(Oflo, 0)
end


function signalNZO(res)
    stin(Neg, res[1])
    stin(Zero, all(x->x == 0, res))
    # stin(Oflo, xmax | xmin)
end

#---------------------------------------
#--  Floating Point Domain Signaling  --
#---------------------------------------

function singal11FNZ(r1)
    # DEC PDP11 float numeric result

    # flstatus[Neg] = r1[Coef[1]]
    flstatus[Zero] = all(x->x == 0, r1)
    flstatus[Oflo] = 0
    flstatus[Carry] = 0
end

function signal11FNZO(res)
    # DEC PDP11 float arithmetic result

    flstatus[Neg] = res < 0
    flstatus[Zero] = res == 0
    # flstatus[Oflo] = xmax
    flstatus[Carry] = 0
end

#--------------------------------------
#--      Instruction Sequencing      --
#--------------------------------------

function cycle11()
    # Basic cycle of DEC PDP11
    
    while(!stop)
        interrupt11()
        # execute(ifetch11())
    end
end

function ifetch11()
    return read11(incr11(word, Pc))
end

#---------------------------
#--      Supervision      --
#---------------------------

function adrcheck11(location)
    # DEC PDP11 address check
    
    throw("Not implemented!")
    # report(Spec, location >= memcap)
    # Spec report 0≠(2⌊⍴,location)|⌊/location
end

function suppress11()
    return reduce(|, ind[Spec, Invop])
end

#-------------------------------------
#--      Floating point reports     --
#-------------------------------------

function report11fl(code, condition)
    if(condition)
        fle = magnr(length(fle), code)
        # report(Fle, 1)
    end
end

#----------------------
#--   Interruption   --
#----------------------

function interrupt11()
    local who
    local old
    local new

    progint11()
    who = findfirst(x->x == 1, ind)

    if who != length(ind)
        ind[who] = 0
        old = stout(collect(1:word))
        # push11(old)
        # push11(reg[Pc,:])
        reg[Pc,:] = read11([word memadr Intvec[who]])
        # report(Spec, (magni(reg[Pc,;]) % 2) == 1)
        new = read11([word memadr 2 + Intvec[who]])
        new[Previousmode] = old[Currentmode]
        # stin(iword, new)
    end
    # report(Bpt, stout(Trace))
    throw("Not implemented loop with `wait`")
end

function progint11()
    local who = 7 - findfirst(x->x == 1, read11([byte memadr Piw])[1:7])
    if who > magni(stout(Priority))
        local nr = magnr(byte, who * 34)
        write11([byte memadr Piw + 1], nr)
        # report(Pir, 1)
    end
end

#------------------------------
#--      Other Functions     --
#------------------------------

function execute(inst)
    # ⍎ ⍕oplist[decode inst;]
    throw("Not implemented!")
    # oplist[decode(inst, form, oplist, orop),:]
end

function report(which, cond)
    ind[which] = reduce(|, [ind[which] cond])
end

#------------------------------------
#--      invalid Instructions      --
#------------------------------------

function i()
    report(Invop, 1)
    println("Invalid instruction!")
end

#-----------------------------------------------------------------------------
#--                             Sintax PDP-11                               --
#-----------------------------------------------------------------------------

ind[Spec] = ind[Invop] = 0

oplist = [i, MOV, CMP, BIT, BIC, BIS, i, i, ADD, SUB, MUL, DIV, ASH, ASHC, XOR, i, i, SOB, i, BR, BNE, BEQ, BGE, BLT, BGT, BLE, i, i, i, i, i, i, i, i, BPL, BMI, BHI, BLOS, BVC, BVS, BCC, BCS, EMT, TRAP, i, i, i, i, i, i, i, i, MULF, MODF, ADDF, LDF, SUBF, CMPF, STF, DIVF, STEX, STCI, STCF, LDEX, LDCI, LDCF, JSR, CLR, COM, INC, DEC, NEG, ADC, SBC, TST, ROR, ROL, ASR, ASL, i, JMP, i, SWAB, MARK, i, i, SXT, i, LDFS, STFS, STST, CLRF, TSTF, ABSF, NEGF, RTS, SPL, CLCC, SECC, HALT, WAIT, RTI, BPT, IOT, RSET, RTT, i, CFCC, SETF, SETI, i, i, i, i, i, i, SETD, SETL, i, i, i, i, i]




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


orop =2 .^ reduce(+, reduce(&, form, dims = 3), dims = 2)
orop = [reduce(+, orop[1:i]) for i = 1:length(orop)]
loper = pop!(orop)
pushfirst!(orop, 0)
orop = orop .+ 1

end #module pdp11