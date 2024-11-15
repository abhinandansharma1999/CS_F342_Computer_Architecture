module array_multiplier_6bit (p, a, b);
input [5:0]a;
input [5:0]b;
output [11:0]p;

wire [5:0]row[5:0];
wire [6:0]partial_product[4:0]; 

anding AND1 (.row(row[0]), .a(a), .b0(b[0]));
anding AND2 (.row(row[1]), .a(a), .b0(b[1]));
anding AND3 (.row(row[2]), .a(a), .b0(b[2]));
anding AND4 (.row(row[3]), .a(a), .b0(b[3]));
anding AND5 (.row(row[4]), .a(a), .b0(b[4]));
anding AND6 (.row(row[5]), .a(a), .b0(b[5]));

adding1 ADD11 (.out(partial_product[0]), .in1(row[0][5:1]), .in2(row[1]));
adding ADD1 (.out(partial_product[1]), .in1(partial_product[0][6:1]), .in2(row[2]));
adding ADD2 (.out(partial_product[2]), .in1(partial_product[1][6:1]), .in2(row[3]));
adding ADD3 (.out(partial_product[3]), .in1(partial_product[2][6:1]), .in2(row[4]));
adding ADD4 (.out(partial_product[4]), .in1(partial_product[3][6:1]), .in2(row[5]));

// Output Assignment
buf b0 (p[0], row[0][0]);

buf b1 (p[1], partial_product[0][0]);
buf b2 (p[2], partial_product[1][0]);
buf b3 (p[3], partial_product[2][0]);
buf b4 (p[4], partial_product[3][0]);

buf b5 (p[5], partial_product[4][0]);
buf b6 (p[6], partial_product[4][1]);
buf b7 (p[7], partial_product[4][2]);
buf b8 (p[8], partial_product[4][3]);
buf b9 (p[9], partial_product[4][4]);
buf b10 (p[10], partial_product[4][5]);
buf b11 (p[11], partial_product[4][6]);

endmodule


// Add operation for first row
module adding1 (out, in1, in2);
input [4:0] in1;
input [5:0] in2;
output [6:0] out;

RCA_5bit RA11 (.sum(out[4:0]), .cout(cout), .a(in1), .b(in2[4:0])); 
half_adder HA31 (.sum(out[5]), .cout(out[6]), .a(in2[5]), .b(cout));

endmodule

// Add operations
module adding (out, in1, in2);
input [5:0] in1;
input [5:0] in2;
output [6:0] out;

RCA_6bit RA21 (.sum(out), .a(in1), .b(in2));

endmodule

// And operations
module anding (row, a, b0);
input [5:0]a;
input b0;
output [5:0] row;

and a1 (row[0], a[0], b0);
and a2 (row[1], a[1], b0);
and a3 (row[2], a[2], b0);
and a4 (row[3], a[3], b0);
and a5 (row[4], a[4], b0);
and a6 (row[5], a[5], b0);

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

// for first row
module RCA_5bit (sum, cout, a, b);
input [4:0] a;
input [4:0] b;
output [4:0] sum;
output cout;

wire c[4:0];

half_adder HA11 (.sum(sum[0]), .cout(c[0]), .a(a[0]), .b(b[0]));
full_adder FA11 (.sum(sum[1]), .cout(c[1]), .a(a[1]), .b(b[1]), .cin(c[0]));
full_adder FA12 (.sum(sum[2]), .cout(c[2]), .a(a[2]), .b(b[2]), .cin(c[1]));
full_adder FA13 (.sum(sum[3]), .cout(c[3]), .a(a[3]), .b(b[3]), .cin(c[2]));
full_adder FA14 (.sum(sum[4]), .cout(c[4]), .a(a[4]), .b(b[4]), .cin(c[3]));

buf b11 (cout, c[4]);
endmodule

// For remaining rows
module RCA_6bit (sum, a, b);
input [5:0] a;
input [5:0] b;
output [6:0] sum;

wire cout[5:0];

half_adder HA21 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]));
full_adder FA21 (.sum(sum[1]), .cout(cout[1]), .a(a[1]), .b(b[1]), .cin(cout[0]));
full_adder FA22 (.sum(sum[2]), .cout(cout[2]), .a(a[2]), .b(b[2]), .cin(cout[1]));
full_adder FA23 (.sum(sum[3]), .cout(cout[3]), .a(a[3]), .b(b[3]), .cin(cout[2]));
full_adder FA24 (.sum(sum[4]), .cout(cout[4]), .a(a[4]), .b(b[4]), .cin(cout[3]));
full_adder FA25 (.sum(sum[5]), .cout(cout[5]), .a(a[5]), .b(b[5]), .cin(cout[4]));

buf b21 (sum[6], cout[5]);
endmodule


//Testbench
module tb_array_multiplier_6bit();
wire [11:0] p;
reg [5:0] a;
reg [5:0] b;

parameter T = 20;

array_multiplier_6bit uut (.p(p), .a(a), .b(b));

initial
begin
$monitor("a=%b	b=%b	p=%b", a, b, p);

a = 6'b111111;
b = 6'b111111;
#(T)
a = 6'b000000;
b = 6'b000000;
#(T)
a = 6'b110101;
b = 6'b010110;
#(T)
a = 6'b101001;
b = 6'b001111;
#(T)
a = 6'b110111;
b = 6'b011111;
#(T)
a = 6'b011111;
b = 6'b110111;
#(T)
a = 6'b100010;
b = 6'b001110;
#(T)
a = 6'b101111;
b = 6'b101111;

end
endmodule