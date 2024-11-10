module RCA_4bit (sum, a, b);
input [3:0] a;
input [3:0] b;
output [4:0] sum;

wire cout[3:0];

half_adder HA1 (.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]));
full_adder FA1 (.sum(sum[1]), .cout(cout[1]), .a(a[1]), .b(b[1]), .cin(cout[0]));
full_adder FA2 (.sum(sum[2]), .cout(cout[2]), .a(a[2]), .b(b[2]), .cin(cout[1]));
full_adder FA3 (.sum(sum[3]), .cout(cout[3]), .a(a[3]), .b(b[3]), .cin(cout[2]));

buf b1 (sum[4], cout[3]);
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
module tb_RCA_4bit ();
wire [4:0] sum;
reg [3:0] a;
reg [3:0] b;

parameter T=20;

RCA_4bit uut (.sum(sum), .a(a), .b(b));

initial
begin
$monitor("a=%b	b=%b	sum=%b", a, b, sum);

a = 4'b0000;
b = 4'b0000;
#T
a = 4'b1111;
b = 4'b1111;
#T
a = 4'b0101;
b = 4'b1010;
#T
a = 4'b1100;
b = 4'b1001;
#T
a = 4'b0010;
b = 4'b0011;
#T
a = 4'b1101;
b = 4'b0111;

end
endmodule
