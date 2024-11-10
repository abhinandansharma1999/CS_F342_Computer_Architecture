module normalize (out1, exp_extra, in1);
input [69:0] in1;
output reg [22:0] out1;
output reg [7:0] exp_extra;

integer count;
integer i;
reg [69:0] in;
reg [7:0] shift;

always@(*)
begin

in = in1;
shift = 8'b0;

while (in[69] == 0) begin
	in = {in[68:0], 1'b0};
	shift = shift + 8'd1;
end

out1 = in[68 : (68-22)];
exp_extra = 8'd23 - shift;

end
endmodule



// testbench
module tb_normalize ();
reg [69:0] in1;
wire [22:0] out1;
wire [7:0] exp_extra;

normalize uut (out1, exp_extra, in1);

initial begin
$monitor("%b_%b_%b_%b	%b  %b", in1[69:46], in1[45:23], in1[22:20], in1[19:0], out1, exp_extra);

in1 = 70'b000000000000000000010001_10101101011110000011111_111_00000000000000000000;
#10
in1 = 70'b000000000000000000000010_01010000000100100101011_001_00000000000000000000;
#10
in1 = 70'b000000000000000000000001_10111011110001110111110_100_00000000000000000000;
#10
in1 = 70'b000000000000000000000000_00000000000000111011001_111_00000000000000000000;

end
endmodule