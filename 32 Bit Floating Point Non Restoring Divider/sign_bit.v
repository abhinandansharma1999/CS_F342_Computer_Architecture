module sign_bit (AbyB_sign, in1, in2);
input [31:0] in1, in2;
output AbyB_sign;

assign AbyB_sign = in1[31] ^ in2[31];

endmodule