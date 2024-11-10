module shift_reg_PISO_8bit (out, din, clk, load_shift);
input [7:0] din;
input load_shift, clk;
output reg out;

reg [7:0] temp;

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





