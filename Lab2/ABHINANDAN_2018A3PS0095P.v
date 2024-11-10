// Name: ABHINANDAN SHARMA
// ID  : 2018A3PS0095P
// Lab : 2
//********************************Q1***************************************************************

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

//*************************************Q2**********************************************************

`timescale 1ns/1ns
module D_FF_AR (q, q_bar, clk, d, reset);
input clk, d, reset;
output reg q, q_bar;

always@(posedge clk, reset) 
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
module tb_D_FF_AR ();
reg clk, d, reset;
wire q, q_bar;

parameter T = 20;

D_FF_AR uut (.q(q), .q_bar(q_bar), .clk(clk), .d(d), .reset(reset));

initial
begin
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin
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

//*************************************Q3**********************************************************

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

//*****************************************Q4******************************************************

module decoder_2to4 (out, in);
input [1:0] in;
output reg [3:0] out;

always@(*)
begin

case (in)
	2'b00 	: out = 4'b0001;
	2'b01 	: out = 4'b0010;
	2'b10 	: out = 4'b0100;
	2'b11 	: out = 4'b1000;
	default	: out = 4'b0;
endcase

end
endmodule


//Testbench
module tb_decoder_2to4();
reg [1:0]in;
wire [3:0]out;

decoder_2to4 uut (.in(in), .out(out));

initial
begin

$monitor("in=%b	out=%b", in, out);

in = 2'b00;
#10
in = 2'b01;
#10
in = 2'b10;
#10
in = 2'b11;
end
endmodule

//******************************Q5*****************************************************************

module shift_reg_PISO_8bit (out, din, clk, load_shift);
input [7:0] din;
input load_shift, clk;
output reg out;

reg [7:0] temp = 8'b0;

always@(posedge clk)
begin

if (load_shift)
begin
	temp = din;
	out = temp[0];
end

else
begin
	temp = {1'b0, temp[7:1]};
	out = temp[0];
end

end
endmodule


//Testbench
module tb_shift_reg_PISO_8bit();
reg [7:0] din;
reg clk, load_shift;
wire out;

parameter T = 20;

shift_reg_PISO_8bit uut (.out(out), .din(din), .clk(clk), .load_shift(load_shift));

initial
begin
clk = 1'b1;
forever #(T/2) clk = ~clk;
end

initial
begin

$monitor ($time, "	din=%b	load_shift=%b	out=%b", din, load_shift, out);

din = 8'b10011101;
load_shift = 1;

#T 
load_shift = 0;

#(5*T)
load_shift = 1;
din = 8'b01001011;

#T
load_shift = 0;

#(7*T) $stop;

end
endmodule

//*****************************************Q6******************************************************

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
