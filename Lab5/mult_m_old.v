`timescale 1ns/1ns
module mult_m (P, clk, A, B);	//Multi Cycle
input [7:0] A, B;
input clk;
output [15:0] P;

wire [7:0] P_P;			//Partial Products
wire [15:0] P_P_S;		//Shifted Partial Products
wire [1:0] counter;		//To keep track of control signals
wire [3:0] A_in, B_in;	//inputs to multiplier

counter_mod4 CM1 (.counter(counter), .clk(clk));	//negedge triggered
mux_mult MM1 (.A_in(A_in), .B_in(B_in), .A(A), .B(B), .sel_in(counter));	
mult_4bit M4B1 (.P_P(P_P), .A_in(A_in), .B_in(B_in), .clk(clk));
append_zeros AZ1 (.P_P_S(P_P_S), .P_P(P_P), .sel_sh(counter), .clk(clk));
accumulator_16bit A1 (.P(P), .P_P_S(P_P_S), .sel_add(counter), .clk(clk));

endmodule

//counterer negedge triggered
module counter_mod4 (counter, clk);
input clk;
output [1:0] counter;

reg [1:0]counter = 2'b00;

always@ (negedge clk)
begin
	if (counter == 2'b11)
		counter = 2'b00;
	else
		counter = counter + 2'b01;
end

endmodule

//mux deciding input for multiplier
module mux_mult (A_in, B_in, A, B, sel_in);
input [7:0] A, B;
input [1:0] sel_in;
output reg [3:0] A_in, B_in;

always@(sel_in)
begin
	case (sel_in)
		2'b00	:	begin
						B_in = B[3:0];
						A_in = A[3:0];
					end
					
		2'b01	:	begin
						B_in = B[3:0];
						A_in = A[7:4];
					end
					
		2'b10	:	begin
						B_in = B[7:4];
						A_in = A[3:0];
					end
					
		2'b11	:	begin
						B_in = B[7:4];
						A_in = A[7:4];
					end	
					
		default	:	begin
						B_in = B[3:0];
						A_in = A[3:0];
					end
	endcase
end

endmodule

//Multiplier 4 bit
module mult_4bit (P_P, A_in, B_in, clk);
input [3:0] A_in, B_in;
input clk;
output reg [7:0] P_P;

always@(posedge clk)
begin
	P_P = A_in * B_in;
end

endmodule

//Appending zeroes
module append_zeros (P_P_S, P_P, sel_sh, clk);
input [7:0] P_P;
input [1:0] sel_sh;
input clk;
output reg [15:0]P_P_S;

reg garbage;

always@(posedge clk)
begin
	case (sel_sh)
		2'b00	:	P_P_S = {8'd0, P_P};
		2'b01	:	P_P_S = {4'd0, P_P, 4'd0};
		2'b10	:	P_P_S = {4'd0, P_P, 4'd0};
		2'b11	:	P_P_S = {P_P, 8'd0};
		default :   garbage = 1'b1;
	endcase
end

endmodule

//Accumulate addends and then add on 4th clk cycle
module accumulator_16bit (P, P_P_S, sel_add, clk);
input [15:0] P_P_S;
input [1:0] sel_add;
input clk;
output reg [15:0] P;

reg garbage;
reg [15:0] addend [3:0];

always@(posedge clk)
begin
	case (sel_add)
		2'b00	:	addend[0] = P_P_S;
		2'b01	:	addend[1] = P_P_S;
		2'b10	:	addend[2] = P_P_S;
		2'b11	:	begin
						addend[3] = P_P_S;
						P = (addend[0] + addend[1] + addend[2] + addend[3]);
					end
		default:	garbage = 1'b1;
	endcase
end

endmodule

//Testbench
module tb_mult_m();
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
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);
	
	A = 8'd255;
	B = 8'd255;
	#(4*T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);	
	
	A = 8'd76;
	B = 8'd106;
	#(4*T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);	
	
	A = 8'd120;
	B = 8'd55;
	#(4*T);
	$display($time, "   A = %b	B = %b	P = %d", A, B, P);	
	
	#T
	$finish;
end	

endmodule