module mult_p (P, clk, A, B);	//Pipelined approach
input [7:0] A, B;
input clk;
output reg [15:0] P;

reg [7:0] P_P [3:0];		//Partial Products
reg [15:0] P_P_S [3:0];		//Shifted Partial Products
reg [7:0] A_in [3:0];		//input to multiplier
reg [7:0] B_in [3:0];		//input to multiplier
reg [15:0] addend [3:0];	//P_P_S ready to be added

always@(posedge clk)
begin
	fork
		begin
			A_in[0] = A;
			B_in[0] = B;
			P_P[0] = A_in[0][3:0] * B_in[0][3:0];
			P_P_S[0] = {8'd0, P_P[0]};
		end
		
		begin
			A_in[1] = A_in[0];
			B_in[1] = B_in[0];
			P_P[1] = A_in[1][7:4] * B_in[1][3:0];
			P_P_S[1] = P_P_S[0] + {4'd0, P_P[1], 4'd0};
		end
		
		begin
			A_in[2] = A_in[1];
			B_in[2] = B_in[1];
			P_P[2] = A_in[2][3:0] * B_in[2][7:4];
			P_P_S[2] = P_P_S[1] + {4'd0, P_P[2], 4'd0};
		end
		
		begin
			A_in[3] = A_in[2];
			B_in[3] = B_in[2];
			P_P[3] = A_in[3][7:4] * B_in[3][7:4];
			P_P_S[3] = P_P_S[2] + {P_P[3], 8'd0};
		end
	join
	
	P = P_P_S[3];
end
endmodule


//Testbench
module tb_mult_p ();
reg [7:0] A, B;
reg clk;
wire [15:0] P;

parameter T = 50;

mult_p uut (P, clk, A, B);

initial
begin
	clk = 1'b0;
	forever #(T/2) clk = ~clk;
end

initial
begin
	$dumpfile("mult_p.vcd");
	$dumpvars(0);
	
	A = 8'd127;
	B = 8'd127;
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	
	A = 8'd255;
	B = 8'd255;
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);	
	
	A = 8'd76;
	B = 8'd106;
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);	
	
	A = 8'd120;
	B = 8'd55;
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	
	$finish;
end	

endmodule