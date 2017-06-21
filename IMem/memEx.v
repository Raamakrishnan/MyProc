module memEx;
integer i;
reg [31:0] memory [0:15]; // 32 bit memory with 16 entries

initial begin
    for (i=0; i<16; i++) begin
        memory[i] = i;
    end
    $writememb("memory_binary.txt", memory);
    $writememb("memory_binary.bin", memory);
    $writememh("memory_hex.txt", memory);
    $writememh("memory_hex.hex", memory);
    $readmemh("memory_hex.hex", memory);
    //for(i=0;i<16;i++) begin
    //	$display("%h \n", memory[i]);
    //end
end
endmodule