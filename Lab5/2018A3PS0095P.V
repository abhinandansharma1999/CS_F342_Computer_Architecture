// Name: ABHINANDAN SHARMA
// ID  : 2018A3PS0095P
// Lab : 5
//********************************Q1***************************************************************

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

//********************************Q2***************************************************************

module mult_m (P, clk, A, B);	//Multi Cycle
input [7:0] A, B;
input clk;
output reg [15:0] P;

reg [7:0] P_P;				//Partial Products
reg [15:0] P_P_S;			//Shifted Partial Products
reg [1:0] counter = 2'b0;	//To keep track of control signals
reg [3:0] A_in, B_in;		//inputs to multiplier
reg [15:0] addend [3:0];

always@(posedge clk)
begin
	case (counter)
		2'b00	:	begin
						B_in = B[3:0];
						A_in = A[3:0];
						P_P = A_in * B_in;
						P_P_S = {8'd0, P_P};
						addend[0] = P_P_S;
					end
					
		2'b01	:	begin
						B_in = B[3:0];
						A_in = A[7:4];
						P_P = A_in * B_in;
						P_P_S = {4'd0, P_P, 4'd0};
						addend[1] = P_P_S;
					end
					
		2'b10	:	begin
						B_in = B[7:4];
						A_in = A[3:0];
						P_P = A_in * B_in;
						P_P_S = {4'd0, P_P, 4'd0};
						addend[2] = P_P_S;
					end
					
		2'b11	:	begin
						B_in = B[7:4];
						A_in = A[7:4];
						P_P = A_in * B_in;
						P_P_S = {P_P, 8'd0};
						addend[3] = P_P_S;
						P = (addend[0] + addend[1] + addend[2] + addend[3]);
					end	
					
		default	:	begin
						P = 15'd0;
					end
	endcase

	if (counter == 2'b11)
		counter = 2'b00;
	else
		counter = counter + 2'b01;
end
endmodule


//Testbench
module tb_mult_m ();
reg [7:0] A, B;
reg clk;
wire [15:0] P;

parameter T = 10;

mult_m uut (P, clk, A, B);

initial
begin
	clk = 1'b0;
	forever #(T/2) clk = ~clk;
end

initial
begin
	A = 8'd127;
	B = 8'd127;
	#(4*T);
	$display($time, "   A = %d	B = %d	P = %d", A, B, P);
	
	A = 8'd255;
	B = 8'd255;
	#(4*T);
	$display($time, "   A = %d	B = %d	P = %d", A, B, P);	
	
	A = 8'd76;
	B = 8'd106;
	#(4*T);
	$display($time, "   A = %d	B = %d	P = %d", A, B, P);	
	
	A = 8'd120;
	B = 8'd55;
	#(4*T);
	$display($time, "   A = %d	B = %d	P = %d", A, B, P);	
	
	#T
	$finish;
end	

endmodule

//********************************Q3***************************************************************

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
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);	//output starts coming on each posedge
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	#(T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	
	$finish;
end	

endmodule