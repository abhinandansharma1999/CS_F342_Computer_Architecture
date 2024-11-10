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

//$dumpfile("wave.vcd");
//$dumpvars(0, tb_memory_64byte);

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
