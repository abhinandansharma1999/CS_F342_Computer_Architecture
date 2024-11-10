module memory_64byte (dout, address, din, wen, ren, clk);
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

module bin_to_gray (out_gray, in_binary);
output[7:0] out_gray;
input[7:0] in_binary;

assign out_gray[0] = in_binary[0] ^ in_binary[1];
assign out_gray[1] = in_binary[1] ^ in_binary[2];
assign out_gray[2] = in_binary[2] ^ in_binary[3];
assign out_gray[3] = in_binary[3] ^ in_binary[4];
assign out_gray[4] = in_binary[4] ^ in_binary[5];
assign out_gray[5] = in_binary[5] ^ in_binary[6];
assign out_gray[6] = in_binary[6] ^ in_binary[7];
assign out_gray[7] = in_binary[7];

endmodule


//testbench
module tb_memory_64byte;
wire [7:0] dout, gray;
reg [7:0] din, binary;
reg [5:0] address;
reg wen, ren, clk;

parameter T = 10;

memory_64byte uut1 (.dout(dout), .address(address), .din(din), .wen(wen), .ren(ren), .clk(clk));
bin_to_gray uut2 (.out_gray(gray), .in_binary(binary));

initial
begin
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin

$dumpfile("wave.vcd");
$dumpvars(0, tb_memory_64byte);

#1;
address = 6'b0;
ren = 1'b1;
wen = 1'b1;

repeat(64)
begin
	#1 $display("binary data = %h at address = %h",dout,address);
	binary = dout;
	#1 din = gray;
	#8 address = address +1'b1;
end

#10
wen = 1'b0;

repeat(64)
begin
	#1 $display("gray data = %h at address = %h",dout,address);
	#1 address = address + 1'b1;
end

$finish;

end
endmodule
