module exponent (out1, in1, in2);
input [31:0] in1, in2;
output [7:0] out1;

wire [7:0] A_exp;
wire [7:0] B_exp;
wire [7:0] A_exp_final;
wire [7:0] B_exp_final;
wire [8:0] temp1;
wire [8:0] temp2;

assign A_exp = in1[30:23];
assign B_exp = in2[30:23];

assign A_exp_final = (A_exp == 8'b0) ? 8'b00000001 : A_exp;
assign B_exp_final = (B_exp == 8'b0) ? 8'b00000001 : B_exp;

complement_2s  #(.N1(7)) COMP (.comp_2s(temp1), .in1(B_exp_final));

RCA  #(.N(7)) RCA_exp (.sum(temp2), .a(A_exp_final), .b({temp1[7:0]}));	
	
assign out1 = temp2[7:0];

endmodule



/*

// testbench
module tb_exponent ();
reg [31:0] in1, in2;
wire [7:0] out1;

exponent uut (out1, in1, in2);

initial begin
$monitor("%b	%b	%b", in1, in2, out1);

in1 = 32'b1_11111111_11111111111111111111111;
in2 = 32'b1_11111111_11111111111111111111111;
#10
in1 = 32'b0_000011111_1111111111111000000001;
in2 = 32'b1_111100000_0000000000001110000111;
#10
in1 = 32'b1_110000011_1111111111111111100001;
in2 = 32'b1_111111000_1111111111111100001111;
#10
in1 = 32'b1_110000111_1111111111111111110000;
in2 = 32'b1_000111111_1111111111111111000011;

end
endmodule

//*************************************************************************************************
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


*/