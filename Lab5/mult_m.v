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