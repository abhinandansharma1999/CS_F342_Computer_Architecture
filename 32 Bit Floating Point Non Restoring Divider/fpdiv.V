module fpdiv (AbyB,DONE,EXCEPTION,InputA,InputB,CLOCK,RESET);
input CLOCK,RESET ; // Active High Synchronous Reset
input [31:0] InputA,InputB ;
output [31:0]AbyB;
output DONE ; // ‘0’ while calculating, ‘1’ when the result is ready
output [1:0]EXCEPTION; // Used to output exceptions

wire [4:0] exceptions_A;
wire [4:0] exceptions_B;
wire [22:0] AbyB_mant_norm;
wire [22:0] AbyB_mant_norm_final;
wire [49:0] AbyB_mant_unnorm;
wire [23:0] dividend;
wire [23:0] divisor;
wire AbyB_sign;
wire AbyB_over; 
wire AbyB_subnormal;
wire [7:0] AbyB_exp_initial;
wire [7:0] AbyB_exp;
wire [31:0] AbyB_valid;
wire [7:0] exp_extra;

exception_signals ES1 (.exceptions_A(exceptions_A), .exceptions_B(exceptions_B), .A(InputA), .B(InputB));
sign_bit SB1 (.AbyB_sign(AbyB_sign), .in1(InputA), .in2(InputB));
exponent EXP11 (.out1(AbyB_exp_initial), .in1(InputA), .in2(InputB));

assign dividend = (exceptions_A[1] == 1'b1) ? {1'b0, InputA[22:0]} : {1'b1, InputA[22:0]};
assign divisor = (exceptions_B[1] == 1'b1) ? {1'b0, InputB[22:0]} : {1'b1, InputB[22:0]};

non_restoration_division NRD1 (.dividend(dividend), .divisor(divisor), .result(AbyB_mant_unnorm));
normalize NORM1 (.out1(AbyB_mant_norm), .exp_extra(exp_extra), .in1({AbyB_mant_unnorm, 20'd0}));

overflow_check OFC11 (.AbyB_over(AbyB_over), .AbyB_exp_initial(AbyB_exp_initial), .exp_extra(exp_extra));
underflow_check UFC11 (.AbyB_under(AbyB_under), .AbyB_subnormal(AbyB_subnormal), .AbyB_exp_initial(AbyB_exp_initial), .exp_extra(exp_extra));

assign AbyB_exp = (AbyB_subnormal == 1'b1) ? 8'b0 : (AbyB_exp_initial + exp_extra + 8'd127);
assign AbyB_mant_norm_final = (AbyB_subnormal == 1'b1) ? {1'b1, AbyB_mant_norm[22:1]} : AbyB_mant_norm;

assign AbyB_valid = {AbyB_sign, AbyB_exp, AbyB_mant_norm_final};

final_assignment FASN1 (.AbyB(AbyB), .DONE(DONE), .EXCEPTION(EXCEPTION), .CLOCK(CLOCK), .RESET(RESET), .exceptions_A(exceptions_A),
 .exceptions_B(exceptions_B), .AbyB_valid(AbyB_valid), .AbyB_under(AbyB_under), .AbyB_over(AbyB_over));

endmodule