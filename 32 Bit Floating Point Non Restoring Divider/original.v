module non_restoration_division (dividend, divisor, result);
input [26:0] dividend;
input [26:0] divisor;
output [26:0] result;

wire [27:0] A [27:0];
wire [26:0] Q [27:0]; 
wire [27:0] B = {divisor[26], divisor};
wire [27:0] B_2s;

assign A[0] = 28'b0;
assign Q[0] = dividend;

complement_2s C2S (.comp_2s(B_2s), .in1(divisor));

generate
	genvar i;
	for (i = 0; i <= 26; i = i+1) begin
		iterations IT (.Q_out(Q[i+1]), .A_out(A[i+1]), .Q_in(Q[i]), .A_in(A[i]), .B(B), .B_2s(B_2s));
	end
endgenerate

assign result = Q[27];
endmodule

module iterations (Q_out, A_out, Q_in, A_in, B, B_2s);
input [27:0] A_in;
input [26:0] Q_in;
input [27:0] B;
input [27:0] B_2s;
output [27:0] A_out;
output [26:0] Q_out;

wire [27:0] b;

assign b = (A_in[26] == 1'b1) ? B : B_2s;

RCA_no_cout RCANC11 (.sum(A_out), .a({A_in[26:0], Q_in[26]}), .b(b));

assign Q_out = (A_out[27] == 1'b1) ? {Q_in[25:0], 1'b0} : {Q_in[25:0], 1'b1};

endmodule

module complement_2s (comp_2s, in1);
input [26:0] in1;
output [27:0] comp_2s;

wire [26:0] comp_1s;
wire [26:0] temp;
assign comp_1s = ~(in1);

RCA_no_cout #(.N(26)) RCANC21 (.sum(temp), .a(comp_1s), .b(27'd1));

assign comp_2s = {temp[26], temp};
endmodule

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

module RCA_no_cout #(parameter N = 27) (sum, a, b);
input [N:0] a;
input [N:0] b;
output [N:0] sum;

wire cout[N:0];

half_adder HA11 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]));

generate
	genvar i;
	for (i = 1; i <= N; i = i+1) begin
		full_adder FA11 (.sum(sum[i]), .cout(cout[i]), .a(a[i]), .b(b[i]), .cin(cout[i-1]));
	end
endgenerate

endmodule

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

//Half Adder
module half_adder (sum, cout, a, b);
input a, b;
output sum, cout;

xor X1 (sum, a, b);
and A1 (cout, a, b);
endmodule


//Testbench
module tb_non_restoration_division();
reg [26:0] dividend;
reg [26:0] divisor;
wire [26:0] result;

reg [26:0] out;

non_restoration_division uut(.result(result), .dividend(dividend), .divisor(divisor));

initial
begin

$monitor("dividend = %b	divisor = %b	result = %b	ans= %b", dividend, divisor, result, out);

dividend = 27'b101000;
divisor = 27'b1000;
#10
dividend = 27'b1010101001000101001000;
divisor = 27'b11010010101001010101000;
#10
dividend = 27'b111111111111111111111111000;
divisor = 27'b010101010000;
#10
dividend = 27'b010001010101010101001000000;
divisor = 27'b110101010101001010101010000;
#10
dividend = 27'b1011110101001000;
divisor = 27'b101010010000100001000011000;
#10
dividend = 27'b10110100101001001000;
divisor = 27'b11101010001001001001001000;
#10
dividend = 27'b1011110100101000010001000;
divisor = 27'b1101001010001000;	

#10
dividend = 27'b101000000000010000000000000;
divisor = 27'b000100011010100010101001011;

end

always@(*)
begin
out = dividend/divisor;
end

endmodule
