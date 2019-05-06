include("pdp11.jl")

function basicTestingDecode(instructionToDecode = Missing)#instructionVector::AbstractVector{Int8}=0) #Missing to test charged function else instruction as argument like => vec(Int8[0 1 1 0 0 1 0 0 0 0 0 0 0 0 0 1])
 
    if( instructionToDecode == Missing)
        #All of this should return true
        println(pdp11.basics.decode(vec(Int8[0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.ADD, " ADD Function")
        
        println(pdp11.basics.decode(vec(Int8[0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.BIS, " BIS Function")
        
        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.ASL, " ASL Function")

        println(pdp11.basics.decode(vec(Int8[1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.ROR, " ROR Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.CLR, " CLR Function")

        println(pdp11.basics.decode(vec(Int8[0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.XOR, " XOR Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.DEC, " DEC Function")

        println(pdp11.basics.decode(vec(Int8[1 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.SUB, " SUB Function")
        
        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.SBC, " SBC Function")
        
        println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 0 1 0 0 0 0 1 0 1 1 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.DIV, " DIV Function")

        println(pdp11.basics.decode(vec(Int8[1 1 1 1 1 1 1 0 0 0 0 1 0 1 1 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.LDCI," LDCI Function")
        
        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.COM, " COM Function")

        println(pdp11.basics.decode(vec(Int8[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.BIC, " BIC Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 0 0 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.ROL, " ROL Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.SWAB, " SWAB Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.SXT, " SXT Function")

        println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 1 1 0 1 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.ASHC, " ASHC Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.NEG, " NEG Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 0 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.ADC, " ADC Function")

        println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.MUL, "MUL Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.TST, " TST Function")
    else
        pdp11.basics.decode(instructionToDecode,pdp11.form,pdp11.oplist,pdp11.orop) #Instruction in particular
    end
end

function testingBasicFunctions()
    local testing

    testing=pdp11.basics.radixcompi(vec(Int8[1 0 0 0]))
    println(testing==BigInt(-8))
    
    testing=pdp11.basics.radixcompr(253, 999999999999999999999999999999999999999999999999999999999999999999999999999 )
    println( testing[2]===0 && testing[3]===0)

    testing = pdp11.basics.radixcompr(4, -8)
    println( testing[2]===0 && testing[3]===0)

    testing = pdp11.basics.radixcompr(3, -8)
    println( testing[2]===1 && testing[3]===0)



    
end

function testingDecode( )#instructionVector::AbstractVector{Int8}=0) #0 to test charged function else instruction as argument like => vec(Int8[0 1 1 0 0 1 0 0 0 0 0 0 0 0 0 1])
 
    #All of this should return true
    println(pdp11.basics.decode(vec(Int8[0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.ADD, " ADD Function")
    
    println(pdp11.basics.decode(vec(Int8[0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.BIS, " BIS Function")
    
    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.ASL, " ASL Function")

    println(pdp11.basics.decode(vec(Int8[1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.ROR, " ROR Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.CLR, " CLR Function")

    println(pdp11.basics.decode(vec(Int8[0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.XOR, " XOR Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.DEC, " DEC Function")

    println(pdp11.basics.decode(vec(Int8[1 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.SUB, " SUB Function")
    
    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.SBC, " SBC Function")
    
    println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 0 1 0 0 0 0 1 0 1 1 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.DIV, " DIV Function")

    println(pdp11.basics.decode(vec(Int8[1 1 1 1 1 1 1 0 0 0 0 1 0 1 1 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.LDCI," LDCI Function")
    
    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.COM, " COM Function")

    println(pdp11.basics.decode(vec(Int8[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.BIC, " BIC Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 0 0 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.ROL, " ROL Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.SWAB, " SWAB Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.SXT, " SXT Function")

    println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 1 1 0 1 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.ASHC, " ASHC Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.NEG, " NEG Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 0 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.ADC, " ADC Function")

    println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.MUL, "MUL Function")

    println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 1 1 0 0 0 0 0 0]),pdp11.form,pdp11.oplist,pdp11.orop) == pdp11.inst_set11.TST, " TST Function")
    
#pdp11.basics.decode(instructionVector,pdp11.form,pdp11.oplist,pdp11.orop)
end
