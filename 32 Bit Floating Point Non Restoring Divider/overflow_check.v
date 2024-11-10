module overflow_check (AbyB_over, AbyB_exp_initial, exp_extra);
input [7:0] AbyB_exp_initial;
input [7:0] exp_extra;
output reg AbyB_over;

reg [8:0] sum;

always@(*)
begin

sum = (AbyB_exp_initial + exp_extra + 8'd127);

if ((sum == 9'b011111111) || (sum[8] == 1'b1))
	AbyB_over = 1'b1;
else
	AbyB_over = 1'b0;

end
endmodule