module inst_set11

export oplist

#------------------------------------
#--      invalid Instructions      --
#------------------------------------
function i()
    println("instrucci'on inv'alida")
end


# ------------------------------------
# -- Data Manipulation Instructions --
# ------------------------------------

function MOV()
    # od ← read11 size11 adr11 Source
    # (size11 adr11 Dest) write11 od
    # signal11NZ od
end

# --------------------------------
# --    Logical Instructions    --
# --------------------------------

function CLR()
    # dest←size11 adr11 Dest
    # dest write11 size11⍴0
    # signal11NZ 0
    # Carry stin 0
end

function COM()
    # dest←size11 adr11 Dest
    # rl ← ~read11 dest
    # dest write11 rl
    # signal11NZ rl
end

function BIC()
    # dest←size11 adr11 Dest
    # od1←read11 size11 adr11 Source
    # od2 ← read11 dest
    # rl← od2∧~od1
    # dest write11 rl
    # signal11NZ rl
end

function ASHC()
    # dest←byte adr11 Dest 
    
    # ⍝ Size of the shift
    # shift ←radixcompi ¯6↑read11 dest 
    
    # ⍝ The 2 Registers where it will be loaded the long number
    # od←regout fld Source[R]
    # od←od,regout odd11 fld Source[R]
    # value←radixcompi od
    
    # ⍝ Depending on the value of shift, it will be right or left
    # result←value×radix*shift

    # rl←long radixcompr⌊result
    # (fld Source[R]) regin word ↑ rl
    # (odd11 fld Source[R]) regin word ↓ rl
    
    # ⍝ Add a 0 to the last position where it will be the last bit shifted, which will be loaded into Carry
    # Carry stin ¯1↑shift⌽od,0
    # signal11NZO rl
end

function ROL()
    # dest←size11 adr11 Dest
    # od←read11 dest
    # rl←1↓od, stout Carry
    # dest write11 rl
    # Carry stin 1↑od
    # signal11NZ rl
    # Oflo stin≠/2↑od
end

function XOR()
    # ≠ is XOR
    #   od1←regout fld Source[R]
    #   dest←word adr11 Dest
    #   od2←read11 dest
    #   result←od1≠od2
    #   dest write11 result
    #   signal11NZ result
end

function BIS()
    # od1← read11 size11 adr11 Source
    # dest← size11 adr11 Dest
    # od2← read11 dest
    # r1← od2 ∨ od1
    # dest write11 r1
    # signal11NZ r1  
end

function BIT()
    # od1← read11 size11 adr11 Source
    # od2← read11 size11 adr11 Dest
    # r1← od2 ∧ od1
    # signal11NZ r1
end

function ASL()
    # dest← size11 adr11 Dest
    # od1← read11 dest
    # value←radixcompi od1
    # result← value×radix
    # r1← size11 radixcompr result
    # dest write11 r1
    # Carry stin 1 ↑ od1
    # signal11NZO r1  
end

function ASR()
    # ⍝ Reads destination address
    # dest←size11 adr11 Dest
    # ⍝ Gets operand
    # od←read11 dest
    # ⍝ Shift by duplicating first bit and dropping last    
    # r1←od[0],¯1↓od
    # ⍝ Logic shift is the same, but od[0] is replaced with 0
    # dest write11 r1
    # ⍝ Rewrites bits
    # ⍝ Dropped bit is saved in Carry
    # Carry stin ¯1↑od
    # ⍝ Check flags
    # signal11NZ r1
    # Oflo stin (1↑od)≠¯1↑od
end

function ROR()
    # dest← size11 adr11 Dest
    # od1← read11 dest
    # r1← ¯1↓(stout Carry),od1
    # dest write11 r1
    # Carry stin ¯1 ↑ od1
    # signal11NZ r1
    # Oflo stin (¯1↑od1)≠1↑r1
end

function SWAB()
    # dest←word adr11 Dest
    # od←read11 dest
    # r1←byte⌽od
    # dest write11 r1
    # Carry stin 0
    # signal11NZ r1
end


# -------------------------------
# -- Arithmetical Instructions --
# -------------------------------

function SXT()
    # DEC PDP11 Extend Sign
    # r1← word⍴stout Neg
    # (word adr11 Dest) write11 r1
    # signal11NZ r1    
end

function NEG()
    # DEC PDP11 Negate
    # dest←size11 adr11 Dest
    # od←radixcompi read11 dest
    # rl←size11 radixcompr -(od)
    # dest write11 rl
    # signal11NZO rl
    # Carry stin od≠0
end

function ADD()
    # Non FloatingPoint
    # ad←read11 word adr11 Source
	# ⍝ ad has word bits from "Space[Value]"
	# addend←radixcompi ad
	# ⍝ Interpreted bits as radix complement
	# dest←word adr11 Dest
	# augend←radixcompi read11 dest
	# sum←augend+addend
	# ⍝ APL Add
	# rl←word radixcompr sum
	# ⍝ sum representation as word in rl 
	# dest write11 rl
	# ⍝ write in dest the representation
	# signal11NZO rl
	# cy←word carryfrom augend,addend
	# Carry stin cy
end

function ADC()
    # addend←stout Carry
    # dest←word adr11 Dest
    # ⍝ Interpreted bits as radix complement
    # augend←radixcompi read11 dest
    # sum←augend+addend
	# rl←size11 radixcompr sum

	# ⍝ sum representation as word in rl 
	# dest write11 rl
	# ⍝ write in dest the representation
	# signal11NZO rl
	# cy←word carryfrom augend,addend
	# Carry stin cy
end

function ASH()
    # dest←byte adr11 Dest
    # shift←radixcompi ¯6↑read11 dest
    # od←regout fld Source[R]
    # value←radixcompi od
    # result←value×radix*shift
    # rl←word radixcompr⌊result
    # (fld Source[R]) regin rl
    # Carry stin ¯1↑shift⌽od,0
    # signal11NZO rl
end

function DEC()
    # dest←size11 adr11 Dest
    # od←read11 dest
    # value←radixcompi od
    # result←value-1
    # r1←size11 radixcompr result
    # dest write11 r1
    # signal11NZO r1
end

function SUB()
    # ad←read11 word adr11 Source
	# addend←radixcompi ~ad
	# ⍝ Interpreted bits as radix complement
	# dest←word adr11 Dest
	# augend←radixcompi read11 dest
	# add←addend+augend+1
	# ⍝ APL sub
	# r1←word radixcompr add
	# ⍝ sub representation as word in r1
	# dest write11 r1
	# ⍝ write in dest the representation
	# signal11NZO r1
	# cy←word carryfrom addend,augend,1
	# Carry stin ~cy
end

function SBC()
    # dest←size11 adr11 Dest
	# augend←radixcompi read11 dest
    # ad←size11 radixcompr stout Carry
    # addend←radixcompi ~ad
	# ⍝ APL sbc
	# result←augend + addend + 1
    # ⍝ Reprensentation
    # r1←size11 radixcompr result
	# ⍝ write in dest the representation
	# dest write11 r1
	# ⍝ Flag checks
    # signal11NZ r1
    # Oflo stin xmax
    # Carry stin ~size11 carryfrom augend,addend,1
end

function DIV()
    # dvsr←read11 word adr11 Dest
	# divisor←radixcompi dvsr
    # divz←divisor=0
	# ⍝ Interpreted bits as radix complement
    # dest←fld Source[R]
    # dvnd←(regout dest),regout odd11 dest
    # dividend←radixcompi dvnd
    # ovf←(|radixcompi regout dest)>|divisor
    # →If ~divz∨ovf
	# THEN:
    #     div←⌊dividend÷divisor
    #     rem←dividend-divisor×⌊dividend÷divisor
	#     ⍝ APL div
    #     r2← word radixcompr rem
    #     (word,regadr,odd11 dest) write11 r2
	#     r1←word radixcompr div
    #     (word,regadr,dest) write11 r1
 	#     signal11NZ r1
    # ENDIF:
    # Oflo stin divz∨ovf
    # Carry stin divzdvsr←read11 word adr11 Dest
	# divisor←radixcompi dvsr
    # divz←divisor=0
	# ⍝ Interpreted bits as radix complement
    # dest←fld Source[R]
    # dvnd←(regout dest),regout odd11 dest
    # dividend←radixcompi dvnd
    # ovf←(|radixcompi regout dest)>|divisor
    # →If ~divz∨ovf
	# THEN:
    #     div←⌊dividend÷divisor
    #     rem←dividend-divisor×⌊dividend÷divisor
	#     ⍝ APL div
    #     r2← word radixcompr rem
    #     (word,regadr,odd11 dest) write11 r2
	#     r1←word radixcompr div
    #     (word,regadr,dest) write11 r1
 	#     signal11NZ r1
    # ENDIF:
    # Oflo stin divz∨ovf
    # Carry stin divz
end

function MUL()
    # dest ← fld Source[R]
    # multiplier← radixcompi read11 word adr11 Dest
    # multiplicand← radixcompi reg[dest;]

    # product ← multiplicand × multiplier
    
    # rl ← long radixcompr product
    
    # ⍝ Set high order product 
    # dest regin word ↑ rl

    # ⍝ Set low order product
    # (odd11 dest) regin word ↓ rl
    
    # ⍝ Set flags
    # signal11NZ rl
    # Carry stin ∨/ rl[0] ≠ word ↑ rl
end

function TST()
    # rl ← read11 size11 adr11 Dest
    # signal11NZ rl
    # Carry stin 0
end

function CMP()

end

function INC()

end


# --------------------------------
# -- Floating-point Instruction --
# --------------------------------

function CLRF()
    # dest←size11fl adr11fl Dest
    # dest write11 size11fl⍴0
    # signal11FNZ 0
    # Carry stin 0
end

function LDCI()
    #   size←(word,long)[flstatus[Fl]]
    #   operand←radixcompi size↑read11 size adr11 Dest
    #   flreg[fld Rfl;⍳size11fl]←size11fl fl11r operand
    #   signal11FNZO operand
end

function LDFS()

end

function STFS()

end

function TSTF()

end

function STST()

end

function ABSF()

end

function NEGF()

end

function STCI()
    # STCI DEC PDP11 (store to integer)
end
  
function STEX()
    # STEX DEC PDP11 (store exp's of floating point)
end
  
function ADDF()
# ADDF de PDP11 (floating point add)
end

function MODF()
# MODF de PDP11 (floating point module)
end

function MULF()

end

function LDF()

end
function SUBF()

end
function CMPF()

end
function STF()

end
function DIVF()

end

function STCF()

end

function LDEX()

end

function LDCF()

end

function TESTF()

end
  
#----------------------------
#-- Instruction Sequencing --
#----------------------------
function JMP()

end

function SOB()
# SOB de PDP11
end

function BR()
# BR de PDP11 (incoditional branch)
end

function BNE()
# BNE de PDP11 (not equal branch)
end

function BEQ()
# BEQ de PDP11 (equal branch)
end

function BLT()

end

function BGT()

end

function BGE()

end

function BLE()

end

function BPL()

end

function BMI()

end

function BHI()

end

function BLOS()

end

function BVC()

end

function BVS()

end

function BCC()

end

function BCS()

end

function EMT()

end

function TRAP()

end

function JSR()

end

function RTS()

end

function HALT

end

function WAIT()

end

function RTI()

end

#------------------------------------------------
#--         Miscelaneous Instruction           --
#------------------------------------------------

function MARK()

end

function SPL()

end

function CLCC()

end

function SECC()

end

function BPT()

end

function IOT()

end

function RSET()

end

function RTT()

end

function CFCC()

end

function SETF()

end

function SETI()

end

function SETD()

end

function SETL()

end




#-----------------------------------------------------------------
#--                     oplist                                  --
#-----------------------------------------------------------------
oplist=[i,MOV,CMP,BIT,BIC,BIS,i,i,ADD,SUB,MUL,DIV,ASH,ASHC,XOR,i,
        i,SOB,i,BR,BNE,BEQ,BGE,BLT,BGT,BLE,i,i,i,i,i,i,
        i,i,BPL,BMI,BHI,BLOS,BVC,BVS,BCC,BCS,EMT,TRAP,i,i,i,i,
        i,i,i,i,MULF,MODF,ADDF,LDF,SUBF,CMPF,STF,DIVF,STEX,STCI,STCF,LDEX,
        LDCI,LDCF,JSR,CLR,COM,INC,DEC,NEG,ADC,SBC,TST,ROR,ROL,ASR,ASL,i,
        JMP,i,SWAB,MARK,i,i,SXT,i,LDFS,STFS,STST,CLRF,TSTF,ABSF,NEGF,RTS,
        SPL,CLCC,SECC,HALT,WAIT,RTI,BPT,IOT,RSET,RTT,i,CFCC,SETF,SETI,i,i,
        i,i,i,i,SETD,SETL,i,i,i,i,i]

end