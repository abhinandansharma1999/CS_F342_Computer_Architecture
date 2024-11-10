`timescale 1ns/1ns
module D_FF_SR (q, q_bar, clk, d, reset);
input clk, d, reset;
output reg q, q_bar;

always@(posedge clk) 
begin

if (reset)
begin
	q <= 1'b0;
	q_bar <= 1'b1;
end

else 
begin 
	q <= d;
	q_bar <= ~d;
end

end
endmodule


// Testbench
module tb_D_FF_SR ();
reg clk, d, reset;
wire q, q_bar;

parameter T = 20;

D_FF_SR uut (.q(q), .q_bar(q_bar), .clk(clk), .d(d), .reset(reset));

/* initial
begin
clk = 1'b0;
forever #(T/2) clk = ~clk;
end */

always 
	#(T/2) clk = ~clk;

initial
begin
clk = 1'b0;
reset = 1'b1;
forever #(2*T) reset = ~reset;
end

initial
begin
d = 1'b0;
forever #(T) d = ~d;
end

initial begin
$monitor ($time	, "	clk=%d	reset = %d	d=%d	q=%d	q_bar=%d", clk, reset, d, q, q_bar);

#(10*T) $stop;
end
endmodule


