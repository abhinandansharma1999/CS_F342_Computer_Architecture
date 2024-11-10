module mult_s (P, clk, A, B);	//Single Cycle
input [7:0] A, B;
input clk;
output reg [15:0] P;

reg [7:0] P_P [3:0];		//Partial Products
reg [15:0] P_P_S [3:0];	//Shifted Partial Products
reg [15:0] P_temp;

always@(*)
begin
	// 4bit multiplication
	P_P[0] = B[3:0] * A[3:0];
	P_P[1] = B[3:0] * A[7:4];
	P_P[2] = B[7:4] * A[3:0];
	P_P[3] = B[7:4] * A[7:4];

	//Append zeroes
	P_P_S[0] = {8'b0, P_P[0]};
	P_P_S[1] = {4'b0, P_P[1], 4'b0};
	P_P_S[2] = {4'b0, P_P[2], 4'b0};
	P_P_S[3] = {P_P[3], 8'b0};
	
	// 16 bit Adder
	P_temp = (P_P_S[0] + P_P_S[1] + P_P_S[2] + P_P_S[3]);
end

always@(posedge clk)
begin
	P = P_temp;
end

endmodule


//Testbench
module tb_mult_s();
reg [7:0] A, B;
reg clk;
wire [15:0] P;

parameter T = 40;

mult_s uut (P, clk, A, B);

initial
begin
	clk = 1'b0;
	forever #(T/2) clk = ~clk;
end

initial
begin
	A = 8'd127;
	B = 8'd127;
	#T
	$display("A = %d	B = %d	P = %d", A, B, P);
	
	#T
	A = 8'd255;
	B = 8'd255;
	#T
	$display("A = %d	B = %d	P = %d", A, B, P);	
	
	#T
	A = 8'd76;
	B = 8'd106;
	#T
	$display("A = %d	B = %d	P = %d", A, B, P);	
	
	#T
	A = 8'd120;
	B = 8'd55;
	#T
	$display("A = %d	B = %d	P = %d", A, B, P);	
	
	#T
	$finish;
end	

endmodule
