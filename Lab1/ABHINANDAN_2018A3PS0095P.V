// Name: ABHINANDAN SHARMA
// ID  : 2018A3PS0095P

//********************************Q1******************************************************************************

module full_adder (sum, cout, a, b, cin);
input a, b, cin;
output sum, cout;

assign sum = (a ^ b ^ cin);
assign cout = (a&b | b&cin | cin&a);

endmodule
 
 
// Testbench
module tb_full_adder ();
reg a, b, cin;
wire sum, cout;

integer i,j,k;
full_adder uut (.sum(sum), .cout(cout), .a(a), .b(b), .cin(cin));

initial begin
$monitor("a = %d	b = %d	cin = %d	sum = %d	cout = %d ", a, b, cin, sum, cout);

for(i=0; i<2; i=i+1) begin
	a <= i;
	for(j=0; j<2; j=j+1) begin
		b <= j;
		for(k=0; k<2; k=k+1) begin
			cin <= k;
			#(10);
		end
	end
end

end
endmodule
	
//********************************Q2*****************************************************************************

module mux_4to1 (out, a0, a1, a2, a3, s0, s1);
input a0, a1, a2, a3, s0, s1;
output out;

assign out = s0 ? (s1 ? a3 : a2) : (s1 ? a1 : a0);

endmodule


//Testbench
module tb_mux_4to1 ();
reg a0, a1, a2, a3, s0, s1;
wire out;

integer i, j, k, l, m, n;
mux_4to1 uut (.out(out), .a0(a0), .a1(a1), .a2(a2), .a3(a3), .s0(s0), .s1(s1));

initial begin
$monitor("a0 = %d	a1 = %d	a2 = %d	a3 = %d		s0 = %d	s1 = %d		out = %d ", a0, a1, a2, a3, s0, s1, out);

for(i=0; i<2; i=i+1) begin
	a0 <= i;
	for(j=0; j<2; j=j+1) begin
		a1 <= j;
		for(k=0; k<2; k=k+1) begin
			a2 <= k;
			for(l=0; l<2; l=l+1) begin
				a3 <= l;
				for(m=0; m<2; m=m+1) begin
					s0 <= m;
					for(n=0; n<2; n=n+1) begin
						s1 <= n;
						#(1);
					end
				end
			end
		end
	end
end

end
endmodule

//********************************Q3*****************************************************************************

module shifter (Y, A, Opcode);
input [7:0] A;
input [2:0] Opcode;
output [7:0] Y;

wire [7:0] Y0 = {A[6:0], 1'b0};
wire [7:0] Y1 = {1'b0, A[7:1]};
wire [7:0] Y2 = {A[7], A[7:1]};
wire [7:0] Y3 = {A[6:0], A[7]};
wire [7:0] Y4 = {A[0], A[7:1]};

assign Y = (Opcode == 3'b001) ? Y0 : ((Opcode == 3'b100) ? Y1 : ((Opcode == 3'b101) ? Y2 : ((Opcode == 3'b010) ? Y3 : ((Opcode == 3'b110) ? Y4 : A))));
// In the default case, A is passed as it is without any operation.
endmodule


//Testbench
module tb_shifter();
reg [7:0] A;
reg [2:0] Opcode;
wire [7:0] Y;

shifter uut (.Y(Y), .A(A), .Opcode(Opcode));

initial begin
$monitor("A = %b	Opcode = %b	Y = %b", A, Opcode, Y);

A = 8'b10001100;
Opcode = 3'b001;
#1
Opcode = 3'b100;
#1
Opcode = 3'b101;
#1
Opcode = 3'b010;
#1
Opcode = 3'b110;
#1
Opcode = 3'b000;

end
endmodule


//********************************Q4*****************************************************************************

module BCD_multiplier (PQRS, JKH, LMH);
input [7:0] JKH, LMH;
output [15:0] PQRS;

wire [6:0] JKH_bin, LMH_bin;
wire [13:0] PQRS_bin;

assign JKH_bin = JKH[7:4] * 4'b1010 + JKH[3:0];
assign LMH_bin = LMH[7:4] * 4'b1010 + LMH[3:0];

assign PQRS_bin = JKH_bin * LMH_bin;

assign PQRS[3:0] = PQRS_bin % 10;
assign PQRS[7:4] = ((PQRS_bin - (PQRS_bin % 10)) % 100) / 10;
assign PQRS[11:8] = ((PQRS_bin - (PQRS_bin % 100)) % 1000) / 100;
assign PQRS[15:12] = (PQRS_bin - (PQRS_bin % 1000)) / 1000;

endmodule


//Testbench
module tb_BCD_multiplier ();
reg [7:0] JKH, LMH; 
wire[15:0] PQRS;

BCD_multiplier uut(.PQRS(PQRS), .JKH(JKH), .LMH(LMH));

initial begin
$monitor("JKH = %b	LMH = %b	PQRS = %h", JKH, LMH, PQRS);

JKH = 8'b00000000;	//00
LMH = 8'b00000000;	//00
#1
JKH = 8'b10011001;	//99
LMH = 8'b10011001;	//99
#1
JKH = 8'b10001000;	//88
LMH = 8'b01110111;	//77
#1
JKH = 8'b10000000;	//80
LMH = 8'b01010101;	//55
#1
JKH = 8'b00111001;	//39
LMH = 8'b00100111;	//27
#1
JKH = 8'b10010000;	//90
LMH = 8'b01010101;	//55

end
endmodule