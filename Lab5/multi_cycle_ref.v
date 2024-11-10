module multi_cycle (product, input_A, input_B, clk);

output reg [15:0] product;
input [7:0] input_A, input_B;
input clk;
reg [1:0] count;
reg [4:0] in1, in2;
reg [7:0] pre_product;
reg [15:0] extended_product, accumulated_sum;

always @(count, input_A, input_B)
begin
	case(count)
	2'b00	: begin in1 = input_A[3:0]; in2 = input_B[3:0]; end
	2'b01	: begin in1 = input_A[3:0]; in2 = input_B[7:4]; end
	2'b10	: begin in1 = input_A[7:4]; in2 = input_B[3:0]; end
	2'b11	: begin in1 = input_A[7:4]; in2 = input_B[7:4]; end
	endcase
end

always @(input_A, input_B)
begin
	count = 2'b00;
	accumulated_sum = 16'b0;
	repeat(4)
	begin
		@(posedge clk)
		pre_product = in1*in2;
		case(count)
		2'b00: extended_product = {8'b0,pre_product};
		2'b01: extended_product = {4'b0,pre_product,4'b0};
		2'b10: extended_product = {4'b0,pre_product,4'b0};
		2'b11: extended_product = {pre_product,8'b0};
		endcase
		accumulated_sum = accumulated_sum + extended_product;
		count = count + 1'b1;
	end
	product = accumulated_sum;
end
endmodule