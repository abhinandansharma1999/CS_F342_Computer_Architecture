module memory (dout, address, din, wen, ren, clk);
output reg [7:0] dout;
input [7:0] din;
input [5:0] address;
input wen, ren, clk;
reg [7:0] mem [0:63];

initial
	$readmemb("dummy.txt", mem);
	
always @(negedge clk)
begin
	if(wen) begin
		mem[address] <= din;
		$writememh("gray.txt", mem);
	end
end
 
always @(ren, address)
begin
	if(ren)
		dout <= mem[address];
	else
		dout <= 8'bz;
end

endmodule

module binary_grey (output_grey, input_binary);
output[7:0] output_grey;
input[7:0] input_binary;

assign output_grey[0] = input_binary[0] ^ input_binary[1];
assign output_grey[1] = input_binary[1] ^ input_binary[2];
assign output_grey[2] = input_binary[2] ^ input_binary[3];
assign output_grey[3] = input_binary[3] ^ input_binary[4];
assign output_grey[4] = input_binary[4] ^ input_binary[5];
assign output_grey[5] = input_binary[5] ^ input_binary[6];
assign output_grey[6] = input_binary[6] ^ input_binary[7];
assign output_grey[7] = input_binary[7];

endmodule

module tb_mem;
wire [7:0] dout, grey;
reg [7:0] din, binary;
reg [5:0] address;
reg wen, ren, clk;

memory first_insta(.dout(dout), .address(address), .din(din), .wen(wen), .ren(ren), .clk(clk));
binary_grey demo (.output_grey(grey), .input_binary(binary));

initial
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_mem);
	
	address = 6'b0;
	ren = 1'b1;
	wen = 1'b1;
	#1;
	repeat(64)
	begin
		#1 $display("data = %h at address = %h",dout,address);
		binary = dout;
		#1 din = grey;
		#8 address = address +1'b1;
	end
	#10
	wen = 1'b0;
	repeat(64)
	begin
		#1 $display("modified data = %h at address = %h",dout,address);
		#1 address = address + 1'b1;
	end
	$finish;
end
endmodule
		
