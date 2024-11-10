//NAME1:	ABHINANDAN SHARMA
//ID1  :	2018A3PS0095P
//NAME2:	TANVI SHEWALE
//ID2  :	2018A3PS0298P

//*************************************************************************************************

module fpdiv(AbyB,DONE,EXCEPTION,InputA,InputB,CLOCK,RESET);
input CLOCK,RESET ; // Active High Synchronous Reset
input [31:0] InputA,InputB ;
output [31:0]AbyB;
output DONE ; // ‘0’ while calculating, ‘1’ when the result is ready
output [1:0]EXCEPTION; // Used to output exceptions

wire [22:0] AbyB_mant_norm;
wire [22:0] AbyB_mant_norm_final;
wire [49:0] AbyB_mant_unnorm;
wire [4:0] exceptions_A;
wire [4:0] exceptions_B;
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

final_assignment FASN1 (.AbyB(AbyB), .DONE(DONE), .EXCEPTION(EXCEPTION), .CLOCK(CLOCK), .RESET(RESET), .exceptions_A(exceptions_A), .exceptions_B(exceptions_B), .AbyB_valid(AbyB_valid), .AbyB_under(AbyB_under), .AbyB_over(AbyB_over));

endmodule

//*************************************************************************************************

module exception_signals (exceptions_A, exceptions_B, A, B);
input [31:0] A;
input [31:0] B;
output reg [4:0] exceptions_A;
output reg [4:0] exceptions_B;

wire Sa = A[31];
wire [7:0] Ea = A[30:23];
wire [22:0] Ma = A[22:0];
wire Sb = B[31];
wire [7:0] Eb = B[30:23];
wire [22:0] Mb = B[22:0];

reg A_inf, A_zero, A_nan, A_subnormal, A_dividend;
reg B_inf, B_zero, B_nan, B_subnormal, B_divisor;

always@(*)
begin

{A_inf, A_zero, A_nan, A_subnormal, A_dividend} = 5'b0;
{B_inf, B_zero, B_nan, B_subnormal, B_divisor} = 5'b0;

if (Ea == 8'b1)
begin
	if (Ma == 23'b0)
		A_inf = 1'b1;
	else
		A_nan = 1'b1;
end

else if (Ea == 8'b0)
begin
	if (Ma == 23'b0)
		A_zero = 1'b1;
	else
		A_subnormal = 1'b1;
end

else 
	A_dividend = 1'b1;
	
if (Eb == 8'b1)
begin
	if (Mb == 23'b0)
		B_inf = 1'b1;
	else
		B_nan = 1'b1;
end

else if (Eb == 8'b0)
begin
	if (Mb == 23'b0)
		B_zero = 1'b1;
	else
		B_subnormal = 1'b1;
end

else 
	B_divisor = 1'b1;	
	
exceptions_A = {A_inf, A_zero, A_nan, A_subnormal, A_dividend};
exceptions_B = {B_inf, B_zero, B_nan, B_subnormal, B_divisor};
end
endmodule

//*************************************************************************************************

module sign_bit (AbyB_sign, in1, in2);
input [31:0] in1, in2;
output AbyB_sign;

assign AbyB_sign = in1[31] ^ in2[31];

endmodule

//*************************************************************************************************

module exponent (out1, in1, in2);
input [31:0] in1, in2;
output [7:0] out1;

wire [7:0] A_exp;
wire [7:0] B_exp;
wire [8:0] temp1;
wire [8:0] temp2;

assign A_exp = in1[30:23];
assign B_exp = in2[30:23];

complement_2s  #(.N1(7)) COMP (.comp_2s(temp1), .in1(B_exp));

RCA  #(.N(7)) RCA_exp (.sum(temp2), .a(A_exp), .b({temp1[7:0]}));	
	
assign out1 = temp2[7:0];

endmodule

//*************************************************************************************************

module non_restoration_division (dividend, divisor, result);
input [23:0] dividend;
input [23:0] divisor;
output [49:0] result;

wire [50:0] A [50:0];
wire [49:0] Q [50:0]; 
wire [50:0] B = {27'b0, divisor};
wire [50:0] B_2s;

assign A[0] = 51'b0;
assign Q[0] = {dividend, 26'b0};

complement_2s #(.N1(49)) C2S (.comp_2s(B_2s), .in1(B[	49:0]));

generate
	genvar i;
	for (i = 0; i <= 49; i = i+1) begin
		iterations IT (.Q_out(Q[i+1]), .A_out(A[i+1]), .Q_in(Q[i]), .A_in(A[i]), .B(B), .B_2s(B_2s));
	end
endgenerate

assign result = Q[50];
endmodule

//*************************************************************************************************
module iterations (Q_out, A_out, Q_in, A_in, B, B_2s);
input [50:0] A_in;
input [49:0] Q_in;
input [50:0] B;
input [50:0] B_2s;
output [50:0] A_out;
output [49:0] Q_out;

wire [50:0] b;

assign b = (A_in[48] == 1'b1) ? B : B_2s;

RCA_no_cout #(.N1(50)) RCANC11 (.sum(A_out), .a({A_in[49:0], Q_in[49]}), .b(b));

assign Q_out = (A_out[50] == 1'b1) ? {Q_in[48:0], 1'b0} : {Q_in[48:0], 1'b1};

endmodule

//*************************************************************************************************
module complement_2s #(parameter N1 = 49) (comp_2s, in1);
input [N1:0] in1;
output [(N1+1):0] comp_2s;

wire [N1:0] comp_1s;
wire [N1:0] temp;

assign comp_1s = ~(in1);

RCA_HA #(.N(N1)) RCANC21 (.sum(temp), .a(comp_1s), .b(1'b1));

assign comp_2s = {temp[N1], temp};

endmodule

//*************************************************************************************************
module RCA_HA #(parameter N = 49) (sum, a, b);
input [N:0] a;
input b;
output [N:0] sum;

wire cout[N:0];

half_adder HA11 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b));

generate
	genvar i;
	for (i = 1; i <= N; i = i+1) begin
		half_adder HA12 (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(cout[i-1]));
	end
endgenerate

endmodule

//*************************************************************************************************
module RCA_no_cout #(parameter N1 = 50) (sum, a, b);
input [N1:0] a;
input [N1:0] b;
output [N1:0] sum;

wire cout[N1:0];

half_adder HA11 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]));

generate
	genvar i;
	for (i = 1; i <= N1; i = i+1) begin
		full_adder FA21 (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(b[i]), .cin(cout[i-1]));
	end
endgenerate

endmodule

//*************************************************************************************************
module RCA #(parameter N = 26) (sum, a, b);
input [N:0] a;
input [N:0] b;
output [(N+1):0] sum;

wire cout[N:0];

half_adder HA11 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]));

generate
	genvar i;
	for (i = 1; i <= N; i = i+1) begin
		full_adder FA11 (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(b[i]), .cin(cout[i-1]));
	end
endgenerate

buf b1 (sum[N+1], cout[N]);
endmodule

//*************************************************************************************************
// Full Adder
module full_adder (sum, cout, a, b, cin);
input a, b, cin;
output sum, cout;

wire t1, t2, t3;

xor X1 (sum, a, b, cin);
and A1 (t1, a, b);
and A2 (t2, b, cin);
and A3 (t3, cin, a);

or O1 (cout, t1, t2, t3);
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

//*************************************************************************************************

module overflow_check (AbyB_over, AbyB_exp_initial, exp_extra);
input [7:0] AbyB_exp_initial;
input [7:0] exp_extra;
output reg AbyB_over;

reg [8:0] sum;

always@(*)
begin

sum = (AbyB_exp_initial + exp_extra + 8'd127);

if (sum > 8'd255)
	AbyB_over = 1'b1;
else
	AbyB_over = 1'b0;

end
endmodule

//*************************************************************************************************

module underflow_check(AbyB_under, AbyB_subnormal, AbyB_exp_initial, exp_extra);
input [7:0] AbyB_exp_initial;
input [7:0] exp_extra;
output reg AbyB_under;
output reg AbyB_subnormal;

reg [7:0] sum; 

always@(*)
begin

sum = AbyB_exp_initial + exp_extra + 8'd127;

if (sum == 8'b0)
	AbyB_subnormal = 1'b1;
else
	AbyB_subnormal = 1'b0;
	
if (sum < 8'd0)
	AbyB_under = 1;
else 
	AbyB_under = 0;
end

endmodule

//*************************************************************************************************

module final_assignment(AbyB, DONE, EXCEPTION, CLOCK, RESET, exceptions_A, exceptions_B, AbyB_valid, AbyB_under, AbyB_over);
input [4:0] exceptions_A;
input [4:0] exceptions_B;
input [31:0] AbyB_valid;
input RESET;
input CLOCK;
input AbyB_under;
input AbyB_over;
output reg [31:0] AbyB;
output reg DONE;
output reg [1:0] EXCEPTION;

// exceptions_A = {A_inf, A_zero, A_nan, A_subnormal, A_dividend}

always @ (posedge CLOCK)
	begin
		DONE = 1'b0;
		
		if (RESET)
		begin
		AbyB = 32'b00000000000000000000000000000000;
		end
		
		else
		begin
		casez({exceptions_A, exceptions_B, AbyB_valid[31], AbyB_under, AbyB_over})
		13'b1????_1????_??? :	begin 
								AbyB = 32'b11111111111111111111111111111111; //inf/inf
								EXCEPTION = 2'b11;
								end
		13'b10000_00001_1?? : 	begin 
								AbyB = 32'b11111111100000000000000000000000; //inf/n
								EXCEPTION = 2'b11;
								end	
		13'b1????_????1_0?? : 	begin 
								AbyB = 32'b01111111100000000000000000000000; //inf/n
								EXCEPTION = 2'b11;
								end
		13'b????1_1????_1?? : 	begin 
								AbyB = 32'b10000000000000000000000000000000; //n/inf
								EXCEPTION = 2'b11;
								end
		13'b????1_1????_0?? : 	begin 
								AbyB = 32'b00000000000000000000000000000000; //n/inf
								EXCEPTION = 2'b11;
								end
		13'b1????_?1???_1?? : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //inf/0
								EXCEPTION = 2'b11;
								end	
		13'b1????_?1???_0?? : 	begin 
								AbyB = 32'b01111111100000000000000000000000;  //inf/0
								EXCEPTION = 2'b11;
								end
		13'b?1???_1????_1?? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //0/inf
								EXCEPTION = 2'b11;
								end
		13'b?1???_1????_0?? :	begin 
								AbyB = 32'b00000000000000000000000000000000;  //0/inf
								EXCEPTION = 2'b11;
								end
		13'b?1???_?1???_??? : 	begin 
								AbyB = 32'b11111111111111111111111111111111;  //0/0
								EXCEPTION = 2'b00;
								end
		13'b????1_?1???_1?? : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //n/0
								EXCEPTION = 2'b00;
								end
		13'b????1_?1???_0?? : 	begin 
								AbyB = 32'b01111111100000000000000000000000;  //n/0
								EXCEPTION = 2'b00;
								end
		13'b??1??_?????_??? : 	begin 
								AbyB = 32'b11111111111111111111111111111111;  //A is Nan
								EXCEPTION = 2'b11;
								end
		13'b?????_??1??_??? : 	begin 
								AbyB = 32'b11111111111111111111111111111111;  //B is Nan
								EXCEPTION = 2'b11;
								end
		13'b?1???_????1_1?? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //0/n
								EXCEPTION = 2'bzz;
								end
		13'b?1???_????1_0?? : 	begin 
								AbyB = 32'b00000000000000000000000000000000;  //0/n
								EXCEPTION = 2'bzz;
								end
		13'b????1_????1_?00 : 	begin              //n/n
								AbyB = AbyB_valid;
								EXCEPTION = 2'bzz;
								end
		13'b????1_????1_?1? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //underflow
								EXCEPTION = 2'b01;
								end								
		13'b????1_????1_??1 : 	begin 
								AbyB = 32'b01111111100000000000000000000000;  //overflow
								EXCEPTION = 2'b10;
								end
							
						  
		endcase
		end
		
		DONE = 1'b1;	
	end
endmodule

//*************************************************************************************************

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

//*************************************************************************************************

//Testbench
module tb_non_restoration_division();
reg [23:0] dividend;
reg [23:0] divisor;
wire [49:0] result;

reg [49:0] out;

non_restoration_division uut(.result(result), .dividend(dividend), .divisor(divisor));

initial
begin

$monitor("dividend = %b	divisor = %b	result = %b_%b_%b", dividend, divisor, result[49:26], result[25:3], result[2:0]);

dividend = 24'b110010000000000000000000;
divisor = 24'b000000000000000000000000;
#10
dividend = 24'b000000000000000000000001;
 divisor = 24'b000000000100010100100011;

#10
dividend = 24'b010000101010010101010001;
 divisor = 24'b000000111100010100100011;
#10
dividend = 24'b011111111111111111111111;
 divisor = 24'b100000000000000000000001;
#10
dividend = 24'b110001010101010101001000;
divisor = 24'b010101010101001010101011;
#10
dividend = 24'b101111010100100011010100;
divisor = 24'b111111111100100001000000;
#10
dividend = 24'b101101111111111111111111;
divisor = 24'b011010100010010010010010;
#10
dividend = 24'b100000000000000000000001;
divisor = 24'b100000000000000000000001;
#10
dividend = 24'b000000110001010100101010;
divisor = 24'b000000111100010100100011;
#10
dividend = 24'b110001010101010101001000;
divisor = 24'b010101010101001010101011;
#10
dividend = 24'b110001010101010101001000;
divisor = 24'b110101010101001010101011;

end

endmodule

//*************************************************************************************************
`timescale 1ns/1ns

module tb_fpdiv();
reg CLOCK;
reg RESET;
reg [31:0] InputA;
reg [31:0] InputB;

wire [31:0] AbyB;
wire DONE;
wire [1:0] EXCEPTION;
reg [31:0] ans;

fpdiv uut(.AbyB(AbyB), .DONE(DONE), .EXCEPTION(EXCEPTION), .InputA(InputA), .InputB(InputB), .CLOCK(CLOCK), .RESET(RESET));

always #5 CLOCK = ~CLOCK;

initial 
begin
CLOCK = 1'b1;	
end
	
initial
	begin
	
	$monitor("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b", InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0], EXCEPTION, ans[31],ans[30:23],ans[22:0]);
	RESET = 1'b0;	
	
	#10
	InputA = 32'b11000101011001011011000000000000;
	InputB = 32'b01000011100011111000000000000000;
	ans    = 32'b11000001010011001110000011001000;
	
	#10
	InputA = 32'b01111111100000000000000000000000;
	InputB = 32'b01111111100000000000000000000000; //+inf/+inf
	ans    = 32'b11111111111111111111111111111111; //NaN
	
	#10
	InputA = 32'b11111111100000000000000000000000;
	InputB = 32'b01111111100000000000000000000000; //-inf/+inf
	ans    = 32'b11111111111111111111111111111111; //NaN
	
	#10
	InputA = 32'b11111111100000000000000000000000;
	InputB = 32'b11111111100000000000000000000000; //-inf/-inf
	ans    = 32'b11111111111111111111111111111111; //NaN
	
	#10
	InputA = 32'b01111111100000000000000000000000;
	InputB = 32'b11111111100000000000000000000000; //+inf/-inf
	ans    = 32'b11111111111111111111111111111111; //NaN	
	#10
	
	InputA = 32'b01111111100000000000000000000000;
	InputB = 32'b00101001000010010000000000111111; //+inf/+n
	ans    = 32'b01111111100000000000000000000000; //+inf
	#10
	
	InputA = 32'b11111111100000000000000000000000;
	InputB = 32'b00101001000010010000000000111111; //-inf/+n
	ans    = 32'b11111111100000000000000000000000; //-inf
	
	#10
	InputA = 32'b01111111100000000000000000000000;
	InputB = 32'b10101001000010010000000000111111; //+inf/-n
	ans    = 32'b11111111100000000000000000000000; //-inf
	#10
	InputA = 32'b11111111100000000000000000000000;
	InputB = 32'b10101001000010010000000000111111; //-inf/-n
	ans    = 32'b01111111100000000000000000000000; //+inf
	
	#10
	InputA = 32'b00101001000010010000000000111111;
	InputB = 32'b01111111100000000000000000000000; //+n/+inf
	ans    = 32'b00000000000000000000000000000000; //+0
	#10
	InputA = 32'b00101001000010010000000000111111;
	InputB = 32'b11111111100000000000000000000000; //+n/-inf
	ans    = 32'b10000000000000000000000000000000; //-0
	#10
	InputA = 32'b10101001000010010000000000111111;
	InputB = 32'b01111111100000000000000000000000; //-n/+inf
	ans    = 32'b10000000000000000000000000000000; //-0
	#10
	InputA = 32'b10101001000010010000000000111111;
	InputB = 32'b11111111100000000000000000000000; //-n/-inf
	ans    = 32'b00000000000000000000000000000000; //+0
	
	#10
	InputA = 32'b01111111100000000000000000000000;
	InputB = 32'b00000000000000000000000000000000; //+inf/+0
	ans    = 32'b01111111100000000000000000000000; //+inf
	#10
	InputA = 32'b11111111100000000000000000000000;
	InputB = 32'b00000000000000000000000000000000; //-inf/+0
	ans    = 32'b11111111100000000000000000000000; //-inf
	#10
	InputA = 32'b11111111100000000000000000000000;
	InputB = 32'b10000000000000000000000000000000; //-inf/-0
	ans    = 32'b01111111100000000000000000000000; //+inf
	#10
	InputA = 32'b01111111100000000000000000000000;
	InputB = 32'b10000000000000000000000000000000; //+inf/-0
	ans    = 32'b11111111100000000000000000000000; //-inf
	
	#10
	InputA = 32'b00000000000000000000000000000000;
	InputB = 32'b01111111100000000000000000000000; //+0/+inf
	ans    = 32'b00000000000000000000000000000000; //+0
	#10
	InputA = 32'b10000000000000000000000000000000;
	InputB = 32'b01111111100000000000000000000000; //-0/+inf
	ans    = 32'b10000000000000000000000000000000; //-0
	#10
	InputA = 32'b10000000000000000000000000000000;
	InputB = 32'b11111111100000000000000000000000; //-0/-inf
	ans    = 32'b00000000000000000000000000000000; //+0
	#10
	InputA = 32'b00000000000000000000000000000000;
	InputB = 32'b11111111100000000000000000000000; //+0/-inf
	ans    = 32'b10000000000000000000000000000000; //-0
	
	#10
	InputA = 32'b00000000000000000000000000000000;
	InputB = 32'b00000000000000000000000000000000; //+0/+0
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b10000000000000000000000000000000;
	InputB = 32'b00000000000000000000000000000000; //-0/+0
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b10000000000000000000000000000000;
	InputB = 32'b10000000000000000000000000000000; //-0/-0
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b00000000000000000000000000000000;
	InputB = 32'b10000000000000000000000000000000; //+0/-0
	ans    = 32'b11111111111111111111111111111111; //NaN
	
	#10
	InputA = 32'b00000000000000000000000000000000;
	InputB = 32'b00101001000010010000000000111111; //+0/+n
	ans    = 32'b00000000000000000000000000000000; //+0
	#10
	InputA = 32'b10000000000000000000000000000000;
	InputB = 32'b00101001000010010000000000111111; //-0/+n
	ans    = 32'b10000000000000000000000000000000; //-0
	#10
	InputA = 32'b00000000000000000000000000000000;
	InputB = 32'b10101001000010010000000000111111; //+0/-n
	ans    = 32'b10000000000000000000000000000000; //-0
	#10
	InputA = 32'b10000000000000000000000000000000;
	InputB = 32'b10101001000010010000000000111111; //-0/-n
	ans    = 32'b00000000000000000000000000000000; //+0
		
	#10
	InputA = 32'b00101001000010010000000000111111;
	InputB = 32'b00000000000000000000000000000000; //+n/+0
	ans    = 32'b01111111100000000000000000000000; //+inf
	#10
	InputA = 32'b00101001000010010000000000111111;
	InputB = 32'b10000000000000000000000000000000; //+n/-0
	ans    = 32'b11111111100000000000000000000000; //-inf
	#10
	InputA = 32'b10101001000010010000000000111111;
	InputB = 32'b00000000000000000000000000000000; //-n/+0
	ans    = 32'b11111111100000000000000000000000; //-inf
	#10
	InputA = 32'b10101001000010010000000000111111;
	InputB = 32'b10000000000000000000000000000000; //-n/-0
	ans    = 32'b01111111100000000000000000000000; //+inf
	
	#10
	InputA = 32'b00101001000010010000000000111111;
	InputB = 32'b01111111100000000000000010110100; //+n/+NaN
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b11111111100000000000000010110100;
	InputB = 32'b00101001000010010000000000111111; //-NaN/+n
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b11111111100000000000000010110100;
	InputB = 32'b00000000000000000000000000000000; //-NaN/+0
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b11111111100000000000000010110100;
	InputB = 32'b10000000000000000000000000000000; //-NaN/-0
	ans    = 32'b11111111111111111111111111111111; //NaN
	#10
	InputA = 32'b11111111100000000000000010110100;
	InputB = 32'b11111111100000000000000000000000; //-NaN/-inf
	ans    = 32'b11111111111111111111111111111111; //NaN
	
	// **************************************************************
	
	#10
	InputA = 32'b00010001011111111111111111111111;
	InputB = 32'b00000000011111111111111111111111; //highest normal/highest subnormal
	ans    = 32'b01010000100000000000000000000001;
	#10
	InputA = 32'b00010001011111111111111111111111;
	InputB = 32'b00000000000000000000000000000001; //highest normal/lowest subnormal
	ans    = 32'b01011011111111111111111111111111;
	#10
	InputA = 32'b00010001000000000000000000000001;
	InputB = 32'b00000000000000000000000000000001; //lowest normal/lowest subnormal
	ans    = 32'b01011011100000000000000000000001;
	#10
	InputA = 32'b00010001000000000000000000000001;
	InputB = 32'b00000000011111111111111111111111; //lowest normal/highest subnormal
	ans    = 32'b01010000000000000000000000000010;
	#10
	InputA = 32'b00000000011111111111111111111111;
	InputB = 32'b00010001011111111111111111111111; //highest subnormal/highest normal
	ans    = 32'b00101110011111111111111111111111;
	#10
	InputA = 32'b00000000000000000000000000000001;
	InputB = 32'b00010001011111111111111111111111; //lowest subnormal/highest normal
	ans    = 32'b00100011000000000000000000000001;
	#10
	InputA = 32'b00000000000000000000000000000001;
	InputB = 32'b00010001000000000000000000000001; //lowest subnormal/lowest normal
	ans    = 32'b00100011011111111111111111111110;
	#10
	InputA = 32'b00000000011111111111111111111111;
	InputB = 32'b00010001000000000000000000000001; //highest subnormal/lowest normal
	ans    = 32'b00101110111111111111111111111100;
	#10
	
	InputA = 32'b00010001011111111111111111111111;
	InputB = 32'b00010001011111111111111111111111; //highest normal/highest normal
	ans    = 32'b00111111100000000000000000000000; //1
	#10
	InputA = 32'b00010001011111111111111111111111;
	InputB = 32'b00010001000000000000000000000001; //highest normal/lowest normal
	ans    = 32'b00111111111111111111111111111101;
	#10
	InputA = 32'b00010001000000000000000000000001;
	InputB = 32'b00010001011111111111111111111111; //lowest normal/highest normal
	ans    = 32'b00111111000000000000000000000010;
	#10
	InputA = 32'b00010001000000000000000000000001;
	InputB = 32'b00010001000000000000000000000001; //lowest normal/lowest normal
	ans    = 32'b00111111100000000000000000000000; //1
	
	#10
	InputA = 32'b00000000011111111111111111111111;
	InputB = 32'b00000000011111111111111111111111; //highest subnormal/highest subnormal
	ans    = 32'b00111111100000000000000000000000; //1
	#10
	InputA = 32'b00000000011111111111111111111111;
	InputB = 32'b00000000000000000000000000000001; //highest subnormal/lowest subnormal
	ans    = 32'b01001010111111111111111111111110;
	#10
	InputA = 32'b00000000000000000000000000000001;
	InputB = 32'b00000000011111111111111111111111; //lowest subnormal/highest subnormal
	ans    = 32'b00110100000000000000000000000001;
	#10
	InputA = 32'b00000000000000000000000000000001;
	InputB = 32'b00000000000000000000000000000001; //lowest subnormal/lowest subnormal
	ans    = 32'b00111111100000000000000000000000; //1
	#10

	$stop;
	end
endmodule
	
	