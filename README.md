# MyProc

MyProc is an educational project to create a microprocessor in Verilog. MyProc ISA is inspired from many ISAs, especially from MIPS ISA.

## Instructions
* Each MyProc folder contains an `ISA.txt` with all the details about the ISA used in that version of MyProc
* `ISA.txt` also contains few architectural details of that version of MyProc
* A changelog from the previous version of MyProc ISA is also a present in that file
* Use the `MyProcASM.py` present in that particular MyProc folder for proper assembling of instructions.
* To use `MyProcASM.py`, run `python MyProcASM.py -i <inputfile> -o <outputfile>`
* Run `python MyProcASM.py -h` for further help and some fine points

## MyProc1

This is the first version of the processor. It is a single cycle implementation.

## MyProc2

The second version is a canonical 5 stage pipelined processor.

### Known Issues
* Hazard detection not implemented yet. NOPs should be inserted as and when needed by the programmer
* Shift Left/Right operations not implemented

## Tools Used
* ModelSim
* IVerilog
