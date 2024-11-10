module non_restoration_division_47 (dividend, divisor, result);
input [23:0] dividend;
input [23:0] divisor;
output [47:0] result;

wire [48:0] A [48:0];
wire [47:0] Q [48:0]; 
wire [48:0] B = {25'b0, divisor};
wire [48:0] B_2s;

assign A[0] = 49'b0;
assign Q[0] = {dividend, 24'b0};

complement_2s C2S (.comp_2s(B_2s), .in1(B[47:0]));

generate
	genvar i;
	for (i = 0; i <= 47; i = i+1) begin
		iterations IT (.Q_out(Q[i+1]), .A_out(A[i+1]), .Q_in(Q[i]), .A_in(A[i]), .B(B), .B_2s(B_2s));
	end
endgenerate

assign result = Q[48];
endmodule

//*************************************************************************************************
module iterations (Q_out, A_out, Q_in, A_in, B, B_2s);
input [48:0] A_in;
input [47:0] Q_in;
input [48:0] B;
input [48:0] B_2s;
output [48:0] A_out;
output [47:0] Q_out;

wire [48:0] b;

assign b = (A_in[46] == 1'b1) ? B : B_2s;

RCA_no_cout #(.N1(48)) RCANC11 (.sum(A_out), .a({A_in[47:0], Q_in[47]}), .b(b));

assign Q_out = (A_out[48] == 1'b1) ? {Q_in[46:0], 1'b0} : {Q_in[46:0], 1'b1};

endmodule

//*************************************************************************************************
module complement_2s (comp_2s, in1);
input [47:0] in1;
output [48:0] comp_2s;

wire [47:0] comp_1s;
wire [47:0] temp;

assign comp_1s = ~(in1);

RCA_HA #(.N(47)) RCANC21 (.sum(temp), .a(comp_1s), .b(1'b1));

assign comp_2s = {temp[47], temp};

endmodule

//*************************************************************************************************
module RCA_HA #(parameter N = 47) (sum, a, b);
input [N:0] a;
input b;
output [(N):0] sum;

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
module RCA_no_cout #(parameter N1 = 48) (sum, a, b);
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
module tb_non_restoration_division_47();
reg [23:0] dividend;
reg [23:0] divisor;
wire [47:0] result;

reg [47:0] out;

non_restoration_division_47 uut(.result(result), .dividend(dividend), .divisor(divisor));

initial
begin

$monitor("dividend = %b	divisor = %b	result = %b_%b", dividend, divisor, result[47:24], result[23:0]);

dividend = 24'b000000101010010101010001;
 divisor = 24'b000010100100010100100011;
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
dividend = 24'b010001010101010101001000;
divisor = 24'b010101010101001010101011;
#10
dividend = 24'b001111010100100011010100;
divisor = 24'b001010010000100001000000;
#10
dividend = 24'b001101001010010010001001;
divisor = 24'b011010100010010010010010;
#10
dividend = 24'b000000000000000000000001;
divisor = 24'b100100101000100010100101;
#10
dividend = 24'b011111111111111111111111;
divisor = 24'b111111111111111111111111;

end

endmodule
