import sys
import getopt


insIDict = {"ADDI": 12, "ORI": 13, "ANDI": 14, "LUI": 15, "LDI": 16,
            "LW": 17, "LH": 18, "LD": 19, "SW": 20, "SH": 21, "SD": 22,
            "BEQ": 24, "BNE": 25, "BGTZ": 26, "BLTZ": 27, "BGEZ": 28,
            "BLEZ": 29, "JR": 30, "JALR": 31}
insRDict = {"NOP": 0, "ADD": 1, "SUB": 2, "AND": 3, "OR": 4, "XOR": 5,
            "SLL": 6, "SRL": 7, "SRA": 8, "SLLV": 9, "SRLV": 10,
            "SLT": 23, "MOV": 34, "SWAP": 35, "HALT": 255}
insJDict = {"J": 32, "JAL": 33}
inputfile = ""
outputfile = ""
hexFile = ""


def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print('test.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -i|--ifile <inputfile> -o|--ofile <outputfile>')
            print('''\n A few points: \n 
* Immediate should be a max of 16 bits. Higher bits are silently truncated
* Targets should be a max of 26 bits (even Labels). Higher bits are silently trucated\n''')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
    print('Input file is :', inputfile)
    print('Output file is :', outputfile)

    insFile = open(inputfile)
    hexFile = open(outputfile, mode="w+")
    hexFile.truncate()
    lc = 0
    labelDict = {}

    # first pass
    for line in insFile:
        line = line.strip().upper()

        # remove comments
        if ";" in line:
            s = line.split(";", 1)
            line = s[0]
        # print(line, lc)

        if ":" in line:
            line = line.split(":", 1)
            label = line[0]
            labelDict[label] = lc

        lc += 1

    # print(labelDict)

    insFile.seek(0)
    lc = 0

    # second pas
    for line    in insFile:

        line = line.strip().upper()

        # remove comments
        if ";" in line:
            s = line.split(";", 1)
            line = s[0]
        lc += 1

        # detect labels
        if ":" in line:
            line = line.split(":", 1)
            label = line[0]
            label = label.strip()
            ins = line[1]
            ins = ins.strip()
        else:
            ins = line
            ins = ins.strip()
        inBin = 0
        ins = ins.split(" ", 1)
        op = ins[0].strip().upper()

        # I Type
        if op in insIDict:
            inBin |= insIDict[op] << 24
            r = ins[1].strip()
            ope = r.split(",")
            if len(ope) > 3:
                print("Invalid Arguments at Line: ", lc)
                break
            for i in range(len(ope)):
                ope[i] = ope[i].strip()
                if ope[i] in labelDict and (i == 1 or i == 2):
                    no = (labelDict[ope[i]] - lc) * 4
                    no %= (1 << 16)
                    # if no == no % (1 << 16):
                    inBin |= no
                    # else:
                    #     print("Label Target value should be a max of 16 bits and as the last argument at Line: ", lc)
                if ope[i][0] == "R":
                    no = int(ope[i][1:])
                    if checkReg(no):
                        if i == 0:
                            inBin |= no << 20
                        elif i == 1:
                            inBin |= no << 16
                        else:
                            print("Invalid Argument Register at Line: ", lc)
                            break
                    else:
                        print("Invalid Register number at Line: ", lc)
                        break
                elif isNumber(ope[i]):
                    no = int(ope[i])
                    if i == 1 or i == 2:
                        inBin |= ((no % (1 << 16)) & 0xFFFF)
                        # if no.bit_length() <= 16:
                        # else:
                        #     print("Immediate value should be a max of 16 bits at Line: ", lc)

                    else:
                        print("Invalid Immediate value at Line: ", lc)
                        break
            outToFile(printFormat(inBin), hexFile)

        # R Type
        elif op in insRDict:
            # print(insRDict[op])
            inBin |= insRDict[op] << 24
            if op != "HALT":
                r = ins[1].strip()
                ope = r.split(",")
                if len(ope) > 3:
                    print("Invalid Arguments at Line: ", lc)
                    break
                for i in range(len(ope)):
                    ope[i] = ope[i].strip()
                    if ope[i][0] == "R":
                        no = int(ope[i][1:])
                        if checkReg(no):
                            if i == 0:
                                inBin |= no << 20
                            elif i == 1:
                                inBin |= no << 16
                            elif i == 2:
                                inBin |= no << 12
                            else:
                                print("Invalid Argument Register at Line: ", lc)
                                break
                        else:
                            print("Invalid Register number at Line: ", lc)
                            break
                    else:
                        print("Invalid Argument at Line: ", lc)
                        break
            outToFile(printFormat(inBin), hexFile)

        # J Type
        elif op in insJDict:
            inBin |= insJDict[op] << 24
            imm = ins[1].strip()
            print(imm)
            if imm in labelDict:
                no = labelDict[imm]
                if no.bit_length() <= 26:
                    inBin |= (no * 4);
                    # print(no)
                else:
                    print("Label Target value should be a max of 26 bits at Line: ", lc)
            elif isNumber(imm):
                imm = int(imm)
                if imm.bit_length() <= 26:
                    inBin |= imm
                else:
                    print("Target value should be a max of 26 bits at Line: ", lc)
            else:
                print("Missing Target at Line: ", lc)
            outToFile(printFormat(inBin), hexFile)

        # Invalid instruction
        else:
            print("Invalid Instruction ", op ," at Line: ", lc)
            break
    print("All done!")
    hexFile.close()


def printFormat(n):
    d1, n = divmod(n, 0x1000000)
    d2, n = divmod(n, 0x10000)
    d3, n = divmod(n, 0x100)
    return hex(d1)[2:].zfill(2) + " " + hex(d2)[2:].zfill(2) + " " + hex(d3)[2:].zfill(2) + " " + hex(n)[2:].zfill(2)


def isNumber(s):
    try:
        int(s)
        return True
    except ValueError:
        return False


def outToFile(st, file):
    # print(s)
    file.write(st + "\n")


def checkReg(no):
    if no < 15:
        return True
    else:
        return False


if __name__ == "__main__":
    main(sys.argv[1:])
