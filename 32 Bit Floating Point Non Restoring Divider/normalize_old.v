module normalize_old (out1, dividend, divisor, in1, exceptions_A, exceptions_B);
input [4:0] exceptions_A, exceptions_B;
input [69:0] in1;
input [23:0] dividend, divisor;
output reg [22:0] out1;

wire [22:0] LZ1, LZ2;
integer LZ1_int, LZ2_int;
reg [22:0] exp_extra;
wire [22:0] LZ1_2s;
//wire [] LZ1_minus_LZ2_2s;
//wire [22:0] LZ1_minus_LZ2;

lead_zero LZ1 (.a(dividend), .b(LZ1));
lead_zero LZ2 (.a(divisor), .b(LZ2));
complement_2s (.N1(21)) C2S5B1 (.comp_2s(LZ1_2s), .in1(LZ1));
complement_2s (.N1(21)) C2S5B2 (.comp_2s(LZ1_minus_LZ2_2s), .in1(LZ2));

always@(*)
begin

LZ1_int = LZ1;
LZ2_int = LZ2;

case ({exceptions_A[1], exceptions_B[1]})
	2'b00 	:	begin
				count = 0;
				i = 69;

				while (in1[69] == 0) begin
					in1 = {in1[i:0], 1'b0};
					i = i - 1;
					count = count + 1;
				end
				
				out1 = in1[i, i-22];
				AbuB_exp = 
				end
				
	2'b01 	:	begin
				out1 = in1[(23'b45 + LZ2_int) : (23'b23 + LZ2_int)];
				exp_extra = LZ2;
				end
				
	2'b10 	:	begin
				out1 = in1[(23'b45 - LZ1_int) : (23'b23 - LZ1_int)];
				exp_extra = LZ1_2s;
				end
				
	2'b11 	:	begin
				if (LZ1_int >= LZ2_int) begin
					out1 = in1[(23'b45 - (LZ1_int - LZ2_int)) : 23'b23 - (LZ1_int - LZ2_int)];
					exp_extra = ~(LZ1 - LZ2) + 1;
				end
				
				else begin
					out1 = in1[(23'b44 - (LZ1_int - LZ2_int)) : 23'b22 - (LZ1_int - LZ2_int)];
					exp_extra = ~(LZ1 - LZ2) + 1;
				end
				end
	default	: out1= 4'b0;
endcase

end

module complement_2s #(parameter N1 = 4) (comp_2s, in1);
input [N1:0] in1;
output [(N1+1):0] comp_2s;

wire [N1:0] comp_1s;
wire [N1:0] temp;

assign comp_1s = ~(in1);

RCA_HA #(.N(N1)) RCANC21 (.sum(temp), .a(comp_1s), .b(1'b1));

assign comp_2s = {temp[N1], temp};

endmodule

//*************************************************************************************************
module RCA_HA #(parameter N = 47) (sum, a, b);
input [N:0] a;
input b;
output [N:0] sum;

wire cout[N:0];

half_adder HA31 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b));

generate
	genvar i;
	for (i = 1; i <= N; i = i+1) begin
		half_adder HA12 (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(cout[i-1]));
	end
endgenerate

endmodule

//*************************************************************************************************
//Half Adder
module half_adder (sum, cout, a, b);
input a, b;
output sum, cout;

xor X1 (sum, a, b);
and A1 (cout, a, b);
endmodule

//*************************************************************************************************
module lead_zero(a,b);
input wire [23:0] a;
output reg [4:0]b;

always @(*)
begin

casez(a)
24'b1???????????????????????: b = 5'd0;
24'b01??????????????????????: b = 5'd1;
24'b001?????????????????????: b = 5'd2;
24'b0001????????????????????: b = 5'd3;
24'b00001???????????????????: b = 5'd4;
24'b000001??????????????????: b = 5'd5;
24'b0000001?????????????????: b = 5'd6;
24'b00000001????????????????: b = 5'd7;
24'b000000001???????????????: b = 5'd8;
24'b0000000001??????????????: b = 5'd9;
24'b00000000001?????????????: b = 5'd10;
24'b000000000001????????????: b = 5'd11;
24'b0000000000001???????????: b = 5'd12;
24'b00000000000001??????????: b = 5'd13;
24'b000000000000001?????????: b = 5'd14;
24'b0000000000000001????????: b = 5'd15;
24'b00000000000000001???????: b = 5'd16;
24'b000000000000000001??????: b = 5'd17;
24'b0000000000000000001?????: b = 5'd18;
24'b00000000000000000001????: b = 5'd19;
24'b000000000000000000001???: b = 5'd20;
24'b0000000000000000000001??: b = 5'd21;
24'b00000000000000000000001?: b = 5'd22;
24'b000000000000000000000001: b = 5'd23;
24'b000000000000000000000000: b = 5'd24;
endcase

end

endmodule