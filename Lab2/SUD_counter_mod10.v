`timescale 1ns/1ns
module SUD_counter_mod10 (out, clk, up_down, reset);
input clk, up_down, reset;
output [3:0]out;

reg [3:0]out = 4'b0000;

always@(posedge clk)
begin

if (reset)
	out = 4'b0000;

else if (up_down == 1)
begin
	if (out == 4'b1010)
		out <= 4'b0000;
	else
		out <= out + 4'b0001;
end

else if (up_down == 0)
begin
	if(out == 4'b0000)
		out <= 4'b1010;
	else
		out <= out - 4'b0001;
end

end
endmodule

/*
//testbench
module tb_SUD_counter_mod10();
reg clk, up_down, reset;
wire [3:0] out;

parameter T = 20;

SUD_counter_mod10 uut (.out(out), .clk(clk), .up_down(up_down), .reset(reset));

initial
begin
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin

$monitor ($time, "	reset=%d	up_down=%d	count=%d", reset, up_down, out);

reset = 1'b0;
up_down = 1'b1;

#(5*T); up_down = 0;
#(8*T); up_down = 1;
#(5*T); reset = 1;
#(5*T); reset = 0;
#(5*T); up_down = 0;
#(2*T); $finish;
end

endmodule
*/