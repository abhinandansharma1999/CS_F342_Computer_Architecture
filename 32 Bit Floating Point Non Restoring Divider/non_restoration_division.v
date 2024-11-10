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

dividend = 24'b100000000000000000000001;
 divisor = 24'b111111111111111111111111;
#10
dividend = 24'b000000000000000000000001;
 divisor = 24'b111111111111111111111111;
#10
dividend = 24'b010000000000010000000000;
 divisor = 24'b101111110000000000000000;

/*
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
*/
end

endmodule


