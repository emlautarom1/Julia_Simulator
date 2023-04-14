# Julia Simulator

## Run the PDP11 Machine
```
$ cd Julia_Simulator
$ julia --project=.
julia> include("src/pdp11.jl")
```
### Example
```
julia> pdp11.basics.decode(vec(Int8[1 1 0 1 0 1 0 1 1 1 0 0 0 0 0 1]),pdp11.form,pdp11.oplist,pdp11.orop)
# output: BIS (generic function with 1 method)
```

## Run test suite
```
$ cd Julia_Simulator
$ julia --project=.
# Enter Pkg with ']'
(pdp11) pkg> test
```

## Project Structure

### Basics Machine operations

- **basics.jl**: Contains the basics operations shared between all the machine, such as decoding operation, interpretation and representation operations, floating point operations, etc.

### PDP11 Machine specification
  - **address11.jl**: Contains space names and attributes, loaded before allocation
  - **format11.jl**: Contains Representation Units, Information Units and the addressing capacity.
  - **configure11.jl**: Contains the memory capacity.
  - **space11.jl**: Initializes all the specified spaces of the machine, in this case initializes spaces like, memory spaces, registers, floating registers, indicators, floating point status and exceptions.
  - **name11.jl**: Contains the memory embedding specification,the program status word (Psw), the stack limit (Slw),the interrupt vector, stack pointer, instruction address, I/O Devices as indices in the memory.
  - **name11io.jl**: Contains the I/O memory allocation for the different devices. All of this is given as indices in the memory.
  - **indicator11.jl**: Contains the Program, Breakpoint, I/O, PowerFail, Emulator, General trap, programmed interrupt, Floating point exception indices to check the different flags.
  - **status11.jl**: Contains the Current Mode, Previous Mode, Register Set, interrupt priorities, trace mode, conditions and mode codifications. All of this is given as indices.
  - **status11fl.jl**: Contains the Error, interrupt disable, undefined variable, underflow, overflow, conversion error, double mode, long integer mode, truncation mode, conditions and error codes.
  - **instruction11.jl**: Contains the specification of the instruction format, as
      size specification, operation specification, operand specification, registers operations and bifurcations, unary operations, operation code extension, mode and register. All of this is given as indices.
  - **inst_set11.jl**: Contains all the functions of the architecture to simulate, in this case, all the functions of the PDP11
  - **pdp11.jl**: Contains the addressing of the machine, the floating point and integer domain signaling operations, status operations, addressing, reading and writing operations, interrupt operations, execute, report and invalid operations.
    Also defines an operation list with all the operations defined in the inst_set11.jl file.
  - **testing.jl**: Contains different tests of the operations, mainly are of the basics.jl operations. This in particular calls pdp11.jl first and then you can call the different testing functions inside in it.

## References

- **Gerritt A. Blaauw, Frederick P. Brooks Jr. Frend, Computer Architecture: Concepts and Evolution 1st Edition (Addison-Wesley, 1997)**
