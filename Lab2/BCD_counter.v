`timescale 1ns/1ns
module BCD_counter (count, clk, reset);
input clk, reset;
output [7:0]count;

reg [7:0]count = 8'b0;

always@(posedge clk)
begin

if (reset)
	count = 8'b0;
	
else if (count[3:0] == 4'b1001) begin
	if (count[7:4] == 4'b0101)
		count <= 8'b0;
	
	else begin
		count[7:4] <= count[7:4] + 4'b0001;
		count[3:0] <= 4'b0;
	end
end

else
	count[3:0] = count[3:0] + 4'b0001;
	
end
endmodule


//Testbench
module tb_BCD_counter ();
reg clk, reset;
wire [7:0]count;

parameter T = 20;

BCD_counter uut (.count(count), .clk(clk), .reset(reset));

initial begin
reset = 1'b0;
clk = 1'b0;
#(T/2)
forever #(T/2) clk = ~clk;
end

initial begin

$monitor($time, "	reset=%d    count = %d%d", reset, count[7:4], count[3:0]);

#(15*T) reset = 1'b1;
#(2*T) reset = 1'b0;
#(70*T) $finish;
end

endmodule
