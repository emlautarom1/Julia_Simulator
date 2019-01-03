#------------------------------------------------------------------------------
#--                               pdp-11.jl                                  --
#------------------------------------------------------------------------------
module pdp11
include("./basics.jl")
using OffsetArrays, .basics

export form, orop


#-----------------------------------------------------------------------------
#--                             Sintax PDP-11                               --
#-----------------------------------------------------------------------------
const Byte=0:0
const Source=4:9
const Opcode=1:3
const Dest=10:15
const Opb=4:6
const Opf=4:7
const Offset=8:15
const Ops=8:9
const Cadr=12:15
const Ope=13:15
const Rfl=8:9
const M=1:3
const R=4:6

const dict=Dict{String,Tuple{String,UnitRange{Int64}}}("Byte"=>("10",0:0),                                   
     "Source"=>("10",4:9),                                 
     "OpCode"=>("11",1:3),                                 
     "Dest"=>("10",10:15),
     "RSource"=>("10",7:9),
     "RDest"=>("10",13:15),
     "Opb"=>("11",4:6),
     "Opf"=>("11",4:7),
     "Offset"=>("10",8:15),
     "Ops"=>("11",8:9),
     "Cadr"=>("10",12:15),
     "Ope"=>("11",13:15),
     "Rfl"=>("10",8:9)
    )                                    

form=reshape(zeros(Int8,0),0,0,2)    #init form
form=inPattern(form,"Byte OpCode Source Dest",dict)  
form=inPattern(form,"0 1 1 0 Source Dest",dict) 
form=inPattern(form,"1 1 1 0 Source Dest",dict) 
form=inPattern(form,"0 1 1 1 Opb RSource Dest",dict)  
form=inPattern(form,"0 0 0 0 Opf Offset",dict)  
form=inPattern(form,"1 0 0 0 Opf Offset",dict)  
form=inPattern(form,"1 1 1 1 Opf Rfl Dest",dict)  
form=inPattern(form,"0 0 0 0 1 0 0 RSource Dest",dict)  
form=inPattern(form,"Byte 0 0 0 1 0 1 0 Ops Dest",dict)  
form=inPattern(form,"Byte 0 0 0 1 0 1 1 Ops Dest",dict)  
form=inPattern(form,"Byte 0 0 0 1 1 0 0 Ops Dest",dict)
form=inPattern(form,"0 0 0 0 0 0 0 0 Ops Dest",dict)  
form=inPattern(form,"0 0 0 0 1 1 0 1 Ops Dest",dict)  
form=inPattern(form,"1 1 1 1 0 0 0 0 Ops Dest",dict)  
form=inPattern(form,"1 1 1 1 0 0 0 1 Ops Dest",dict)  
form=inPattern(form,"0 0 0 0 0 0 0 0 1 0 0 0 0 RDest",dict)
form=inPattern(form,"0 0 0 0 0 0 0 0 1 0 0 1 1 RDest",dict)
form=inPattern(form,"0 0 0 0 0 0 0 0 1 0 1 0 Cadr",dict)
form=inPattern(form,"0 0 0 0 0 0 0 0 1 0 1 1 Cadr",dict)
form=inPattern(form,"0 0 0 0 0 0 0 0 0 0 0 0 0 Ope",dict) 
form=inPattern(form,"1 1 1 1 0 0 0 0 0 0 0 0 0 Ope",dict)
form=inPattern(form,"1 1 1 1 0 0 0 0 0 0 0 0 1 Ope",dict)

orop=2 .^ reduce(+,reduce(&,form,dims=3),dims=2)
orop=[reduce(+,orop[1:i]) for i=1:length(orop)]
loper=pop!(orop)
pushfirst!(orop,0)

end #module pdp11