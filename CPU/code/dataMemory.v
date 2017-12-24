`timescale 10ps / 100fs

module dataMemory (
	input wire clock,

	input wire[31:0] readAddress,
	output reg readEnable,
	output reg[511:0] data_out,

	input wire[31:0] writeAddress,
	input wire writeRequest,
	input wire[31:0] writeData,
	output reg writeDone
);

reg[511:0] mem[0:100];

reg[31:0] readAddrOffset;
reg[31:0] writeAddrOffset;
reg[5:0] writeWordOffset;

parameter countNum = 1;

integer readCount, writeCount;

integer i, j;

initial begin 
	for (i = 0; i <= 100; i = i + 1) begin
		mem[i] = {512{1'b0}};
	end
end

initial begin
	writeDone = 1'b1;
	readEnable = 1'b1;
end

always @(posedge writeRequest) begin
	writeDone = 1'b0;
	writeAddrOffset = {6'b0, writeAddress[31:6]};
	writeCount = countNum;
end

always @(posedge readAddress) begin
	readEnable = 1'b0;
	readAddrOffset = {6'b0, readAddress[31:6]};
	readCount = countNum;
end

always @(posedge clock) begin
	if (writeCount == 0 && writeDone == 0) begin
		writeWordOffset = writeAddress[5:0] / 4 * 4;
		case (writeWordOffset)
			6'b000000: mem[writeAddrOffset][0*32+31:0*32] = writeData;
			6'b000100: mem[writeAddrOffset][1*32+31:1*32] = writeData;
			6'b001000: mem[writeAddrOffset][2*32+31:2*32] = writeData;
			6'b001100: mem[writeAddrOffset][3*32+31:3*32] = writeData;
			6'b010000: mem[writeAddrOffset][4*32+31:4*32] = writeData;
			6'b010100: mem[writeAddrOffset][5*32+31:5*32] = writeData;
			6'b011000: mem[writeAddrOffset][6*32+31:6*32] = writeData;
			6'b011100: mem[writeAddrOffset][7*32+31:7*32] = writeData;
				
			6'b100000: mem[writeAddrOffset][8*32+31:8*32] = writeData;
			6'b100100: mem[writeAddrOffset][9*32+31:9*32] = writeData;
			6'b101000: mem[writeAddrOffset][10*32+31:10*32] = writeData;
			6'b101100: mem[writeAddrOffset][11*32+31:11*32] = writeData;
			6'b110000: mem[writeAddrOffset][12*32+31:12*32] = writeData;
			6'b110100: mem[writeAddrOffset][13*32+31:13*32] = writeData;
			6'b111000: mem[writeAddrOffset][14*32+31:14*32] = writeData;
			6'b111100: mem[writeAddrOffset][15*32+31:15*32] = writeData;
		endcase
		writeDone = 1'b1;
	end
	else 
	if (writeCount > 0) writeCount = writeCount - 1;
	if (readCount == 0 && readEnable == 0) begin
		data_out = mem[readAddrOffset];
		readEnable = 1'b1;
	end else 
	if (readCount > 0) readCount = readCount - 1;
end
endmodule
