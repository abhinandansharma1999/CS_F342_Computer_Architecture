`timescale 1ns/1ns
module counter1 (out, clk, up_down, reset);
input clk, up_down, reset;
output [4:0]out;

wire [3:0] out1;
wire [3:0] out2;

SUD_counter_mod10 S1 (.out(out1), .clk(clk), .up_down(up_down), .reset(reset));
SUD_counter_mod10 S2 (.out(out2), .clk(clk), .up_down(up_down), .reset(reset));

assign out = out1 + out2 ;

endmodule

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