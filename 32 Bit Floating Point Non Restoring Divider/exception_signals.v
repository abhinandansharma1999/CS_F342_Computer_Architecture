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

if (Ea == 8'b11111111)
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
	
	
	
if (Eb == 8'b11111111)
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


// testbench
module tb_exception_signals ();
wire [4:0] exceptions_A;
wire [4:0] exceptions_B;
reg [31:0] A;
reg [31:0] B;

exception_signals uut (exceptions_A, exceptions_B, A, B);

initial
begin

$monitor ("A = %b_%b_%b	B = %b_%b_%b	excA = %b	excB = %b", A[31],A[30:23],A[22:0], B[31],B[30:23],B[22:0], exceptions_A, exceptions_B);

	A = 32'b01111111100000000000000000000000;
	B = 32'b01111111100000000000000000000000;
#100	
	A = 32'b01111111100000000000000000000000;
	B = 32'b00101001000010010000000000111111;
#100	
	A = 32'b01111111100000000000000000000000;
	B = 32'b00000000000000000000000000000000;
#100	
	A = 32'b00000000000000000000000000000000;
	B = 32'b01111111100000000000000000000000;
#100	
	A = 32'b00000000000000000000000000000000;
	B = 32'b00000000000000000000000000000000; //+0/+0
#100	
	A = 32'b00000000000000000000000000000000;
	B = 32'b00101001000010010000000000111111; //+0/+n
#100	
	A = 32'b00101001000010010000000000111111;
	B = 32'b00000000000000000000000000000000; //+n/+0
#100	
	A = 32'b00101001000010010000000000111111;
	B = 32'b01111111100000000000000010110100; //+n/+NaN
#100	
	A = 32'b11111111100000000000000010110100;
	B = 32'b00000000000000000000000000000000; //-NaN/+0

end
endmodule