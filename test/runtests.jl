include("../src/pdp11.jl")

using Test

@testset "Basic Decoding" begin
    local test_decode(inst) = pdp11.basics.decode(vec(inst), pdp11.form, pdp11.oplist, pdp11.orop)

    @testset "ADD" begin
        @test test_decode(Int8[0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]) == pdp11.ADD
    end
    @testset "BIS" begin
        @test test_decode(Int8[0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1]) == pdp11.BIS
    end
    @testset "ASL" begin
        @test test_decode(Int8[0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0]) == pdp11.ASL
    end
    @testset "ROR" begin
        @test test_decode(Int8[1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0]) == pdp11.ROR
    end
    @testset "CLR" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0]) == pdp11.CLR
    end
    @testset "XOR" begin
        @test test_decode(Int8[0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1]) == pdp11.XOR
    end
    @testset "DEC" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0]) == pdp11.DEC
    end
    @testset "SUB" begin
        @test test_decode(Int8[1 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0]) == pdp11.SUB
    end
    @testset "SBC" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0]) == pdp11.SBC
    end
    @testset "DIV" begin
        @test test_decode(Int8[0 1 1 1 0 0 1 0 0 0 0 1 0 1 1 1]) == pdp11.DIV
    end
    @testset "LDCI" begin
        @test test_decode(Int8[1 1 1 1 1 1 1 0 0 0 0 1 0 1 1 1]) == pdp11.LDCI
    end
    @testset "COM" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 1]) == pdp11.COM
    end
    @testset "BIC" begin
        @test test_decode(Int8[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1]) == pdp11.BIC
    end
    @testset "ROL" begin
        @test test_decode(Int8[0 0 0 0 1 1 0 0 0 1 0 0 0 0 0 0]) == pdp11.ROL
    end
    @testset "SWAB" begin
        @test test_decode(Int8[0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0]) == pdp11.SWAB
    end
    @testset "SXT" begin
        @test test_decode(Int8[0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 0]) == pdp11.SXT
    end
    @testset "ASHC" begin
        @test test_decode(Int8[0 1 1 1 0 1 1 0 1 0 0 0 0 0 0 0]) == pdp11.ASHC
    end
    @testset "NEG" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0]) == pdp11.NEG
    end
    @testset "ADC" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 1 0 1 0 0 0 0 0 0]) == pdp11.ADC
    end
    @testset "MUL" begin
        @test test_decode(Int8[0 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0]) == pdp11.MUL
    end
    @testset "TST" begin
        @test test_decode(Int8[0 0 0 0 1 0 1 1 1 1 0 0 0 0 0 0]) == pdp11.TST
    end
end

@testset verbose = true "Basic Functions" begin
    @testset "radixcomp(i/r)" begin
        @test pdp11.basics.radixcompi(vec(Int8[1 0 0 0])) == BigInt(-8)
        @test begin
            local testing = pdp11.basics.radixcompr(253, 999999999999999999999999999999999999999999999999999999999999999999999999999)
            testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.radixcompr(4, -8)
            testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.radixcompr(3, -8)
            testing[2] == 1 && testing[3] == 0
        end
    end
    @testset "digitcomp(i/r)" begin
        @test begin
            local testing = pdp11.basics.digitcompi(vec(Int8[1 0 0 0]))
            testing == -7 && typeof(testing) == BigInt
        end
        @test begin
            local testing = pdp11.basics.digitcompi(vec(Int8[0 1 1 1]))
            typeassert(testing, BigInt)
            testing == 7
        end
        @test begin
            local testing = pdp11.basics.digitcompi(vec(Int8[0 0 0 0]))
            typeassert(testing, BigInt)
            testing == 0
        end
        @test begin
            local testing = pdp11.basics.digitcompi(vec(Int8[1 1 1 1]))
            typeassert(testing, BigInt)
            testing == 0
        end
        @test begin
            local testing = pdp11.basics.digitcompr(4, BigInt(8))
            testing[2] == 0 && testing[3] == 1
        end
        @test begin
            local testing = pdp11.basics.digitcompr(4, BigInt(7))
            testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.digitcompr(3, BigInt(-7))
            testing[2] == 1 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.digitcompr(4, 8)
            testing[2] == 0 && testing[3] == 1
        end
        @test begin
            local testing = pdp11.basics.digitcompr(4, 7)
            testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.digitcompr(3, -7)
            testing[2] == 1 && testing[3] == 0
        end
    end

    @testset "bias(i/r)" begin
        @test pdp11.basics.biasi(vec(Int8[0 0 0 0])) == -8
        @test pdp11.basics.biasi(vec(Int8[0 0 0 0 0 0 0 0])) == -128
        @test pdp11.basics.biasi(vec(Int8[1 0 0 0])) == 0
        @test pdp11.basics.biasi(vec(Int8[1 1 1 0])) == 6
        @test begin
            local testing = pdp11.basics.biasr(4, BigInt(7))
            testing[1] == vec(Int8[1 1 1 1]) && testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.biasr(3, BigInt(0))
            testing[1] == vec(Int8[1 0 0]) && testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.biasr(4, BigInt(-8))
            testing[1] == vec(Int8[0 0 0 0]) && testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.biasr(3, BigInt(-7))
            testing[1] == vec(Int8[1 0 1]) && testing[2] == 1 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.biasr(4, 7)
            testing[1] == vec(Int8[1 1 1 1]) && testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.biasr(4, -8)
            testing[1] == vec(Int8[0 0 0 0]) && testing[2] == 0 && testing[3] == 0
        end
        @test begin
            local testing = pdp11.basics.biasr(4, -7)
            testing[1] == vec(Int8[0 0 0 1]) && testing[2] == 0 && testing[3] == 0
        end
    end
end
