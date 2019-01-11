module basics
using OffsetArrays
export +,radix,byte,radixcompi,radixcompr,digitcompi,digitcompr,magni,magnr,signmagni,signmagnr
export biasi,biasr,hidebit,insertbit,truncate,round,trueround,normalize,flbsi,flbsr
export inPattern

import Base.+
+(of::Int64,r::UnitRange{Int64})::UnitRange{Int64} = UnitRange(r[1]+of,r[end]+of)
+(r::UnitRange{Int64},of::Int64)::UnitRange{Int64} = +(of,r)

const radix=2
const log2intradix=(2^(floor(log2(radix)))==radix) ? Int64(log2(radix)) : 0     # 0 when radix is not a power of 2

const plus=0
const minus=1

const byte=8
const Exp=1:8
const Coef= vcat(0, 0,(1+length(Exp))+(0:22))
const base=2
const point=length(Coef)-1
const expextr=radix^(length(Exp)-1)

#-----------------------------------------------------------------
#--                     radix complement                        --
#-----------------------------------------------------------------

function radixcompi(rep::OffsetVector{Int8})::BigInt
    local t::BigInt=rep[0]
    local modulus::BigInt=(convert(BigInt,radix))^length(rep)
    for i in 1:((axes(rep,1).indices)[end])
        t=t*radix+rep[i]
    end
    if t >= (modulus>>1)
        t=t-modulus
    end
    return t
end

function radixcompr(size::Int64,num::BigInt)::Tuple{OffsetVector{Int8},Int64,Int64}
    local xmin=0
    local xmax=0

    t::OffsetArray{Int8}=zeros(Int8,0:size-1)
    local extr::BigInt=div((convert(BigInt,radix))^size,2)
    if num>=extr
        xmax=1
    elseif num<-extr
        xmin=1
    end
    for i in axes(t,1).indices
        t[(axes(t,1).indices)[end]-i]=mod(num,radix)
        num=BigInt(floor(num/radix))
    end
    return (t,xmin,xmax)
end

function radixcompr(size::Int64,num::Int64)::Tuple{OffsetVector{Int8},Int64,Int64}
    local t::BigInt=convert(BigInt,num)
    return radixcompr(size,t)
end

#---------------------------------------------------------
#--                 digit complement                    --
#---------------------------------------------------------

function digitcompi(rep::OffsetArray{Int8})::BigInt
    local t::BigInt=rep[0]
    local modulus::BigInt=(convert(BigInt,radix))^length(rep)-1
    for i in 1:((axes(rep,1).indices)[end])
        t=t*radix+rep[i]
    end
    if t > (modulus>>1)
        t=t-modulus
    end
    return t
end

function digitcompr(size::Int64,num::BigInt)::Tuple{OffsetVector{Int8},Int64,Int64}
    local xmin=0
    local xmax=0

    t::OffsetArray{Int8}=zeros(Int8,0:size-1)
    local extr::BigInt=(convert(BigInt,radix))^(size-1)
    local modulus::BigInt=extr*radix-1
    if num>=extr
        xmax=1
    elseif num<=-extr
        xmin=1
    end
    num=mod(num,modulus)
    for i in axes(t,1).indices
        t[(axes(t,1).indices)[end]-i]=mod(num,radix)
        num=BigInt(floor(num/radix))
    end
    return (t,xmin,xmax)
end

function digitcompr(size::Int64,num::Int64)::Tuple{OffsetVector{Int8},Int64,Int64}
    local t::BigInt=convert(BigInt,num)
    return digitcompr(size,t)
end

#-----------------------------------------------------------------
#--                        magnitude                            --
#-----------------------------------------------------------------

function magni(rep::OffsetVector{Int8})::BigInt
    local t::BigInt=rep[0]
    for i in 1:((axes(rep,1).indices)[end])
        t=(t*radix)+rep[i]
    end
    return t
end

function magnr(size::Int64,num::BigInt)::Tuple{OffsetVector{Int8},Int64,Int64}
    local xmin=0
    local xmax=0

    t::OffsetArray{Int8}=zeros(Int8,0:size-1)
    local extr::BigInt=(convert(BigInt,radix))^size
    if num>=extr
        xmax=1
    elseif num<0
        xmin=1
    end
    for i in axes(t,1).indices
        t[(axes(t,1).indices)[end]-i]=mod(num,radix)
        num=BigInt(floor(num/radix))
    end
    return (t,xmin,xmax)
end

function magnr(size::Int64,num::Int64)::Tuple{OffsetVector{Int8},Int64,Int64}
    local t::BigInt=convert(BigInt,num)
    return magnr(size,t)
end

#-----------------------------------------------------------------
#--                     sign-magnitude                          --
#-----------------------------------------------------------------

function signmagni(rep::OffsetVector{Int8})::BigInt
    local modulus::BigInt=radix^(length(rep)-1)
    local t::BigInt=rep[0]
    for i in 1:((axes(rep,1).indices)[end])
        t=(t*radix)+rep[i]
    end
    t=BigInt((rep[0]==plus) ? 1 : -1) * mod(t,modulus)
    return t 
end

function signmagnr(size::Int64,num::BigInt)::Tuple{OffsetVector{Int8},Int64,Int64}
    local xmin=0
    local xmax=0
    local sign

    t::OffsetArray{Int8}=zeros(Int8,0:size-1)
    local extr::BigInt=(convert(BigInt,radix))^(size-1)
    if num>=extr
        xmax=1
    elseif num<=-extr
        xmin=1
    end
    sign=(num<0) ? minus : plus
    num=(num<0) ? -num : num
    for i in 0:((axes(t,1).indices)[end]-1)
        t[(axes(t,1).indices)[end]-i]=mod(num,radix)
        num=BigInt(floor(num/radix))
    end
    t[0]=sign
    return (t,xmin,xmax)
end

function signmagnr(size::Int64,num::Int64)::Tuple{OffsetVector{Int8},Int64,Int64}
    local t::BigInt=convert(BigInt,num)
    return signmagnr(size,t)
end

#-----------------------------------------------------------------
#--                     bias radix^n/2                          --
#-----------------------------------------------------------------

function biasi(rep::OffsetVector{Int8})::BigInt
    local bias::BigInt=div(radix^length(rep),2)
    local t::BigInt=rep[0]
    for i in 1:((axes(rep,1).indices)[end])
        t=(t*radix)+rep[i]
    end
    return t=t-bias
end

function biasr(size::Int64,num::BigInt)::Tuple{OffsetVector{Int8},Int64,Int64}
    local xmin=0
    local xmax=0
    local sign

    t::OffsetArray{Int8}=zeros(Int8,0:size-1)
    local bias::BigInt=div((convert(BigInt,radix))^size,2)
    if num>=bias
        xmax=1
    elseif num<-bias
        xmin=1
    end
    num=num+bias
    for i in (axes(t,1).indices)
        t[(axes(t,1).indices)[end]-i]=mod(num,radix)
        num=BigInt(floor(num/radix))
    end
    return (t,xmin,xmax)
end

function biasr(size::Int64,num::Int64)::Tuple{OffsetVector{Int8},Int64,Int64}
    local t::BigInt=convert(BigInt,num)
    return biasr(size,t)
end

#--------------------------------------------------------------------------
#--                      floating-point functions                        --
#--------------------------------------------------------------------------

function hidebit(rep::OffsetVector{Int8})::OffsetVector{Int8}
    rep[1]=rep[0]
    return rep
end

function insertbit(rep::OffsetVector{Int8})::OffsetVector{Int8}
    rep[1]=1
    return rep
end

function truncate(num::Real)::BigInt
# truncation to zero
    return BigInt(sign(num)*floor(abs(num)))
end

function round(num::Real)::Real
# algebraic round
    return sign(num)*(floor(0.5+abs(num)))
end

function trueround(num::Real)::Real
# unbiased algebraic round
    local bias::Bool=0.5≠mod(abs(num),2)
    return sign(num)*(floor(0.5*bias+abs(num)))
end

function normalize(expzero::Int64,num::Real,exp::Int64)::Tuple{Int64,Real}
    local exponent::Int64
    local expnorm::Int64
    local coefficient::Real

    if num==0
        exponent=expzero
    else
        expnorm=floor(1+log(base,abs(num))+point-(length(Coef)-1)*log(base,radix))
        exponent=max(expnorm,exp)
    end
    coefficient=num/BigFloat(base)^(exponent-point)
    return (exponent,coefficient)
end

function flbsi(rep::OffsetVector{Int8})::Tuple{Int64,Real}
    local coeff::BigInt=signmagni(insertbit(rep[Coef]))
    local exp::Int64=biasi(rep[Exp])
    local num::BigFloat=coeff*BigFloat(base)^(-point)
    return (exp,num)
end

function flbsr(size::Int64,num::Real,exp::Int64)::Tuple{OffsetVector{Int8},Int64,Int64}
    local rep::OffsetVector{Int8}=zeros(Int8,0:size-1)
    local t,xmax,xmin

    exponent,coefficient=normalize(-expextr,num,-expextr)
    t=signmagnr(length(Coef),BigInt(basics.truncate(coefficient)))[1]
    rep[Exp],xmin,xmax=biasr(length(Exp),BigInt(exponent))
    rep[0]=t[0]
    rep[Coef[3]:Coef[end]]=t[2:end]
    return rep,xmin,xmax
end

#---------------------------------------------------------------------------------
#--          form's initial value = reshape(zeros(Int8,0),0,0,2)                --
#--          dictionary example for PDP-11                                      --
#--          dict=Dict{String,Tuple{String,UnitRange{Int64}}}                   --
#--                  ("Byte"=>("10",0:0),                                       --
#--                   "Source"=>("10",4:9),                                     --
#--                   "OpCode"=>("11",1:3),                                     --
#--                   "Dest"=>("10",10:15))                                     --
#---------------------------------------------------------------------------------
function inPattern(form::Array{Int8,3},patt::String,dict::Dict{String,Tuple{String,UnitRange{Int64}}})::Array{Int8,3}
    local s=size(form)
    local p=replace(replace(patt,r"(0|1)( |$)" => x->"0"*rstrip(x)),r"(?<tok>[a-z][a-z0-9]+( |$))"i=> 
                    x-> (string(dict[rstrip(x)][1]))^length(dict[rstrip(x)][2]))
    local l=div(length(p),2)
    if l<s[2]
        p=rpad(p,s[2]<<1,"10")
        l=s[2]
    end
    if l>s[2]
        # wide the table form
        # Check for a more elegant implementation
        local exp::Array{Int8,3}=reshape(zeros(Int8,s[1]*(l-s[2])*s[3]),(s[1],l-s[2],s[3]))
        exp[:,:,1]=reshape(ones(Int8,s[1]*(l-s[2])),s[1],l-s[2],1)
        form=hcat(form,exp)
    end
    #add pattern to form
    local entry::Array{Int8,3}=reshape(vec(transpose(map(x-> Int8(x)-48,reshape(collect(p),2,l)))),1,l,2)
    form=vcat(form,entry)
end


#-----------------------------------------------------------------
#--            Machine Language Interpretation functions        --
#-----------------------------------------------------------------

function decode(instruction::OffsetArray{Int64, 1},
    form::OffsetArray{Int8,3},
    oplist::OffsetArray{Function,1},
    orop::OffsetArray{Int64,1})::Function
    # OP Code decoding:
    # 11 = opcode
    # 10 = -x-
    # 01 = 1
    # 00 = 0
    local f = form[:; collect(0:length(instruction));:]
 
    let i = size(form)[1] # last match index
        let ty = -1
            while (ty < 0)
            # Check reduce: should reduce in only one dimention
                if reduce(&, (reduce(|, f[i]) .>= instruction)) && reduce(&, (reduce(<, f[i]) .<= instruction))
                    ty = i
                else
                    i -= 1
                end
            end
            return oplist[orop[ty] + magni(instruction[findall(vec(reduce(&, form[1,:,:], dims = 2)))])]
        end
    end
end

end #module