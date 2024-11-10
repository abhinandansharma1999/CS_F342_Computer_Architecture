module underflow_check(AbyB_under, AbyB_subnormal, AbyB_exp_initial, exp_extra);
input [7:0] AbyB_exp_initial;
input [7:0] exp_extra;
output reg AbyB_under;
output reg AbyB_subnormal;

reg [7:0] sum; 

always@(*)
begin

sum = (AbyB_exp_initial + exp_extra + 8'd127);

if (sum == 8'b0) begin
	AbyB_subnormal = 1'b1;
	AbyB_under = 1'b0;
end

else begin
	AbyB_subnormal = 1'b0;
	AbyB_under = 1'b0;
end

if (sum < 8'b0)
	AbyB_under = 1;
else 
	AbyB_under = 0;
end

endmodule

/* //tb
module tb_underflow_check ();
reg [7:0] AbyB_exp_initial;
reg [7:0] exp_extra;
wire reg AbyB_under;
wire reg AbyB_subnormal;

underflow_check uut (AbyB_under, AbyB_subnormal, AbyB_exp_initial, exp_extra);
 */
