module basics

export +,radix,byte,radixcompi,radixcompr,digitcompi,digitcompr,magni,magnr,signmagni,signmagnr
export biasi,biasr,hidebit,insertbit,truncate,round,trueround,normalize,flbsi,flbsr
export inPattern,decode

import Base.+
+(of::Int64, r::UnitRange{Int64})::UnitRange{Int64} = UnitRange(r[1] + of, r[end] + of)
+(r::UnitRange{Int64}, of::Int64)::UnitRange{Int64} = +(of, r)

const radix = 2
const plus = 0
const minus = 1
const byte = 8
const Exp = 2:9
const Coef = vcat(1, 1, (2 + length(Exp)) + (0:22))
const base = 2
const point = length(Coef) - 1
const expextr = radix^(length(Exp) - 1)

#-----------------------------------------------------------------
#--                     radix complement                        --
#-----------------------------------------------------------------

function radixcompi(rep::Vector{Int8})::BigInt
    local t::BigInt = 0;
    try t = rep[1] catch; return 0 end
    local modulus::BigInt = (convert(BigInt, radix))^length(rep)
    for i in 2:(axes(rep, 1)[end])
        t = t * radix + rep[i]
    end
    if t >= (modulus >> 1)
        t = t - modulus
    end
    t
end

function radixcompr(size::Int64, num::BigInt)::Tuple{Vector{Int8},Int64,Int64}
    local xmin = 0
    local xmax = 0

    t::Array{Int8} = zeros(Int8, size)
    local extr::BigInt = div((convert(BigInt, radix))^size, 2)
    if num >= extr
        xmax = 1
    elseif num < -extr
        xmin = 1
    end
    for i in axes(t, 1)
        t[axes(t, 1)[end] - i + 1] = mod(num, radix)
        num = BigInt(floor(num / radix))
    end
    (t, xmin, xmax)
end

function radixcompr(size::Int64, num::Int64)::Tuple{Vector{Int8},Int64,Int64}
    local t::BigInt = convert(BigInt, num)
    radixcompr(size, t)
end

#---------------------------------------------------------
#--                 digit complement                    --
#---------------------------------------------------------

function digitcompi(rep::Array{Int8})::BigInt
    local t::BigInt = 0
    try t = rep[1] catch; return 0 end
    local modulus::BigInt = (convert(BigInt, radix))^length(rep) - 1
    for i in 2:axes(rep, 1)[end]
        t = t * radix + rep[i]
    end
    if t >= modulus / 2
        t = t - modulus
    end
    t
end

function digitcompr(size::Int64, num::BigInt)::Tuple{Vector{Int8},Int64,Int64}
    local xmin = 0
    local xmax = 0

    t::Vector{Int8} = zeros(Int8, size)
    local extr::BigInt = (convert(BigInt, radix))^(size - 1)
    local modulus::BigInt = extr * radix - 1
    if num >= extr
        xmax = 1
    elseif num <= -extr
        xmin = 1
    end
    num = mod(num, modulus)
    for i in axes(t, 1)
        t[axes(t, 1)[end] - i + 1] = mod(num, radix)
        num = BigInt(floor(num / radix))
    end
    (t, xmin, xmax)
end

function digitcompr(size::Int64, num::Int64)::Tuple{Vector{Int8},Int64,Int64}
    local t::BigInt = convert(BigInt, num)
    digitcompr(size, t)
end

#-----------------------------------------------------------------
#--                        magnitude                            --
#-----------------------------------------------------------------

function magni(rep::Vector{Int8})::BigInt
    if isempty(rep)
        0
    else
        local t::BigInt = 0
        for i in rep[2:end] 
            t = (t * radix) + i
        end
        t
    end
end

function magnr(size::Int64, num::BigInt)::Tuple{Vector{Int8},Int64,Int64}
    local xmin = 0
    local xmax = 0

    t::Array{Int8} = zeros(Int8, size)
    local extr::BigInt = BigInt(radix)^size
    if num >= extr
        xmax = 1
    elseif num < 0
        xmin = 1
    end
    for i in axes(t, 1)
        t[axes(t, 1)[end] - i + 1] = mod(num, radix)
        num = BigInt(floor(num / radix))
    end
    (t, xmin, xmax)
end

function magnr(size::Int64, num::Int64)::Tuple{Vector{Int8},Int64,Int64}
    local t::BigInt = convert(BigInt, num)
    magnr(size, t)
end

#-----------------------------------------------------------------
#--                     sign-magnitude                          --
#-----------------------------------------------------------------

function signmagni(rep::Vector{Int8})::BigInt
    try local t::BigInt = rep[1] catch; return 0 end
    local modulus::BigInt = radix^(length(rep) - 1)
    for i in 2:axes(rep, 1)[end]
        t = (t * radix) + rep[i]
    end
    t = BigInt((floor(t / modulus) == 0) ? 1 : -1) * mod(t, modulus)
end

function signmagnr(size::Int64, num::BigInt)::Tuple{Vector{Int8},Int64,Int64}
    local xmin = 0
    local xmax = 0
    local sign

    t::Array{Int8} = zeros(Int8, size)
    local extr::BigInt = (convert(BigInt, radix))^(size - 1)
    if num >= extr
        xmax = 1
    elseif num <= -extr
        xmin = 1
    end
    sign = (num < 0) ? minus : plus
    num = abs(num)
    for i in axes(t, 1)
        t[axes(t, 1)[end] - i + 1] = mod(num, radix)
        num = BigInt(floor(num / radix))
    end
    t[1] = sign
    (t, xmin, xmax)
end

function signmagnr(size::Int64, num::Int64)::Tuple{Vector{Int8},Int64,Int64}
    local t::BigInt = convert(BigInt, num)
    signmagnr(size, t)
end

#-----------------------------------------------------------------
#--                     bias radix^n/2                          --
#-----------------------------------------------------------------

function biasi(rep::Vector{Int8})::BigInt
    local bias::BigInt = div(radix^length(rep), 2)
    try local t::BigInt = rep[1] catch; return 0 end
    for i in 2:axes(rep, 1)[end]
        t = (t * radix) + rep[i]
    end
    t = t - bias
end

function biasr(size::Int64, num::BigInt)::Tuple{Vector{Int8},Int64,Int64}
    local xmin = 0
    local xmax = 0
    local sign

    t::Array{Int8} = zeros(Int8, size)
    local bias::BigInt = div((convert(BigInt, radix))^size, 2)
    if num >= bias
        xmax = 1
    elseif num < -bias
        xmin = 1
    end
    num = num + bias
    for i in axes(t, 1)
        t[axes(t, 1)[end] - i + 1] = mod(num, radix)
        num = BigInt(floor(num / radix))
    end
    (t, xmin, xmax)
end

function biasr(size::Int64, num::Int64)::Tuple{Vector{Int8},Int64,Int64}
    local t::BigInt = convert(BigInt, num)
    biasr(size, t)
end

function wide(sz, in)
    local dim = (sz, Int64(ceil(size(vec(in))[1] / sz)))
    local z = zeros(eltype(in), reduce(*, dim) - length(in))
    in = Array{eltype(in),2}(transpose(reshape(vcat(z, vec(in)), dim)))
end

#--------------------------------------------------------------------------
#--                      floating-point functions                        --
#--------------------------------------------------------------------------

function hidebit(rep::Vector{Int8})::Vector{Int8}
    rep[2] = rep[1]
    return rep
end

function insertbit(rep::Vector{Int8})::Vector{Int8}
    rep[2] = 1
    return rep
end

function truncate(num::Real)::BigInt
# truncation to zero
    BigInt(sign(num) * floor(abs(num)))
end

function round(num::Real)::Real
# algebraic round
    sign(num) * (floor(0.5 + abs(num)))
end

function trueround(num::Real)::Real
# unbiased algebraic round
    local bias::Bool = 0.5 ≠ mod(abs(num), 2)
    sign(num) * (floor(0.5 * bias + abs(num)))
end

function normalize(expzero::Int64, num::Real, exp::Int64)::Tuple{Int64,Real}
    local exponent::Int64
    local expnorm::Int64
    local coefficient::Real

    if num == 0
        exponent = expzero
    else
        expnorm = floor(1 + log(base, abs(num)) + point - (length(Coef) - 1) * log(base, radix))
        exponent = max(expnorm, exp)
    end
    coefficient = num / BigFloat(base)^(exponent - point)
    (exponent, coefficient)
end

function flbsi(rep::Vector{Int8})::Tuple{Int64,Real}
    local coeff::BigInt = signmagni(insertbit(rep[Coef]))
    local exp::Int64 = biasi(rep[Exp])
    local num::BigFloat = coeff * BigFloat(base)^(-point)
    (exp, num)
end

function flbsr(size::Int64, num::Real, exp::Int64)::Tuple{Vector{Int8},Int64,Int64,Int64,Int64}
    local rep::Vector{Int8} = zeros(Int8, size)
    local t, xmax, xmin

    exponent, coefficient = normalize(-expextr, num, -expextr)
    t, xmin, xmax = signmagnr(length(Coef), BigInt(basics.truncate(coefficient)))
    rep[Exp], xmin, xmax = biasr(length(Exp), BigInt(exponent))
    rep[1] = t[1]
    rep[Coef[3]:Coef[end]] = t[3:end]
    local all_zeros = all(x->x == 0, rep[2:end])
    if num < 0.0                          
        if all_zeros                                #very small denormal
            return (rep, 0, 1, 0, 0)            
        else
            return (rep, xmax, xmin, 0, 0)
        end
    else
        if all_zeros && num > 0.0                     #very small denormal
            return (rep, 0, 0, 1, 0)
        else
            return (rep, 0, 0, xmin, xmax)
        end
    end
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
function inPattern(form::Array{Int8,3}, patt::String, dict::Dict{String,Tuple{String,UnitRange{Int64}}})::Array{Int8,3}
    local s = size(form)
    local p = replace(replace(patt, r"(0|1)( |$)" => x->"0" * rstrip(x)), r"(?<tok>[a-z][a-z0-9]+( |$))"i => 
                    x->(string(dict[rstrip(x)][1]))^length(dict[rstrip(x)][2]))
    local l = div(length(p), 2)
    if l < s[2]
        p = rpad(p, s[2] << 1, "10")
        l = s[2]
    end
    if l > s[2]
        # wide the table form
        # Check for a more elegant implementation
        local exp = reshape(zeros(Int8, s[1] * (l - s[2]) * s[3]), (s[1], l - s[2], s[3]))
        exp[:,:,1] = reshape(ones(Int8, s[1] * (l - s[2])), s[1], l - s[2], 1)
        form = hcat(form, exp)
    end
    #add pattern to form
    local entry = reshape(vec(transpose(map(x->Int8(x) - 48, reshape(collect(p), 2, l)))), 1, l, 2)
    form = vcat(form, entry)
end


#-----------------------------------------------------------------
#--            Machine Language Interpretation functions        --
#-----------------------------------------------------------------

function decode(inst::Array{Int8,1}, 
                form::Array{Int8,3}, 
                oplist::Array{Function,1}, 
                orop::Array{Int64,1})::Function
    # OP Code decoding:
    # 11 = opcode
    # 10 = -x-
    # 01 = 1
    # 00 = 0
    local f = form[:, collect(1:length(inst)),:]
 
    let i = size(form)[1] # last match index
        let ty = -1
            while (ty < 0)
            # Check reduce: should reduce in only one dimension
                if reduce(&, (map(|, f[i,:,1], f[i,:,2]) .>= inst)) && reduce(&, (map(<, f[i,:,1], f[i,:,2]) .<= inst))
                    ty = i
                else
                    i -= 1
                end
            end
            local off = Int64(magni(inst[findall(x->x == 1, map(&, f[i,:,1], f[i,:,2]))]))
            return  oplist[orop[ty] + off]
        end
    end
end

end #module