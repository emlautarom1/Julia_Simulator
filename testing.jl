include("pdp11.jl")

function basicTestingDecode(instructionToDecode = Missing)#instructionVector::AbstractVector{Int8}=0) #Missing to test charged function else instruction as argument like => vec(Int8[0 1 1 0 0 1 0 0 0 0 0 0 0 0 0 1])
 
    if( instructionToDecode == Missing)
        #All of this should return true
        println(pdp11.basics.decode(vec(Int8[0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.ADD, " ADD Function")
        
        println(pdp11.basics.decode(vec(Int8[0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.BIS, " BIS Function")
        
        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.ASL, " ASL Function")

        println(pdp11.basics.decode(vec(Int8[1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.ROR, " ROR Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.CLR, " CLR Function")

        println(pdp11.basics.decode(vec(Int8[0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.XOR, " XOR Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.DEC, " DEC Function")

        println(pdp11.basics.decode(vec(Int8[1 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.SUB, " SUB Function")
        
        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.SBC, " SBC Function")
        
        println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 0 1 0 0 0 0 1 0 1 1 1]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.DIV, " DIV Function")

        println(pdp11.basics.decode(vec(Int8[1 1 1 1 1 1 1 0 0 0 0 1 0 1 1 1]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.LDCI, " LDCI Function")
        
        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 1]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.COM, " COM Function")

        println(pdp11.basics.decode(vec(Int8[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.BIC, " BIC Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 0 0 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.ROL, " ROL Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.SWAB, " SWAB Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.SXT, " SXT Function")

        println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 1 1 0 1 0 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.ASHC, " ASHC Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.NEG, " NEG Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 0 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.ADC, " ADC Function")

        println(pdp11.basics.decode(vec(Int8[0 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.MUL, "MUL Function")

        println(pdp11.basics.decode(vec(Int8[0 0 0 0 1 0 1 1 1 1 0 0 0 0 0 0]), pdp11.form, pdp11.oplist, pdp11.orop) == pdp11.TST, " TST Function")
    else
        pdp11.basics.decode(instructionToDecode, pdp11.form, pdp11.oplist, pdp11.orop) #Instruction in particular
    end
end

function testingBasicFunctions()
    local testing


    # Testing radixcompi and radixcompr

    testing = pdp11.basics.radixcompi(vec(Int8[1 0 0 0]))
    println(testing == BigInt(-8))
    
    testing = pdp11.basics.radixcompr(253, 999999999999999999999999999999999999999999999999999999999999999999999999999)
    println(testing[2] === 0 && testing[3] === 0)

    testing = pdp11.basics.radixcompr(4, -8)
    println(testing[2] === 0 && testing[3] === 0)

    testing = pdp11.basics.radixcompr(3, -8)
    println( testing[2]===1 && testing[3]===0)

    # Testing DigitCompr and DigitCompi

    testing = pdp11.basics.digitcompi(vec(Int8[1 0 0 0]))
    println(testing== -7 && typeof(testing)==BigInt)

    testing = pdp11.basics.digitcompi(vec(Int8[0 1 1 1]))
    println(testing== 7 && typeof(testing)==BigInt)

    testing = pdp11.basics.digitcompi(vec(Int8[0 0 0 0]))
    println(testing== 0 && typeof(testing)==BigInt)

    testing = pdp11.basics.digitcompi(vec(Int8[1 1 1 1]))
    println(testing== 0 && typeof(testing)==BigInt)
    
    testing = pdp11.basics.digitcompr( 4 , BigInt(8))
    println(testing[2]==0 && testing[3]==1 )

    testing = pdp11.basics.digitcompr( 4 , BigInt(7))
    println(testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.digitcompr( 3 , BigInt(-7))
    println(testing[2]==1 && testing[3]==0 )


    testing = pdp11.basics.digitcompr( 4 , 8)
    println(testing[2]==0 && testing[3]==1 )

    testing = pdp11.basics.digitcompr( 4 , 7)
    println(testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.digitcompr( 3 , -7)
    println(testing[2]==1 && testing[3]==0 )
    

    # Testing biasi and biasr

    testing = pdp11.basics.biasi(vec(Int8[0 0 0 0]))    
    println( testing == -8)

    testing = pdp11.basics.biasi(vec(Int8[0 0 0 0 0 0 0 0]))    
    println( testing == -128)

    testing = pdp11.basics.biasi(vec(Int8[1 0 0 0]))    
    println( testing == 0)

    testing = pdp11.basics.biasi(vec(Int8[1 1 1 0]))    
    println( testing == 6)


    testing = pdp11.basics.biasr( 4 , BigInt(7))
    println(testing[1]== vec(Int8[1 1 1 1]) && testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.biasr( 3 , BigInt(0))
    println(testing[1]== vec(Int8[1 0 0]) && testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.biasr( 4 , BigInt(-8))
    println(testing[1]== vec(Int8[0 0 0 0]) && testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.biasr( 3 , BigInt(-7))
    println(testing[1]== vec(Int8[1 0 1]) && testing[2]==1 && testing[3]==0 )

    testing = pdp11.basics.biasr( 4 , 7)
    println(testing[1]== vec(Int8[1 1 1 1]) && testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.biasr( 4 , -8)
    println(testing[1]== vec(Int8[0 0 0 0]) && testing[2]==0 && testing[3]==0 )

    testing = pdp11.basics.biasr( 4 , -7)
    println(testing[1]== vec(Int8[0 0 0 1]) && testing[2]==0 && testing[3]==0 )






end
