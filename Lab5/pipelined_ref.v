module pipelined (product, input_A, input_B, clk);

output reg [15:0] product;
input [7:0] input_A, input_B;
input clk;
reg [15:0] sum1, sum2, sum3;
reg [7:0] next_pipeA1, next_pipeA2, next_pipeA3, next_pipeB1, next_pipeB2, next_pipeB3;

always @(input_A, input_B)
begin
	@(posedge clk)
	sum1 <= input_A[3:0]*input_B[3:0];
	next_pipeA1 <= input_A;
	next_pipeB1 <= input_B;
end

always @(sum1)
begin
	@(posedge clk)
	sum2 <= {4'b0,(next_pipeA1[7:4]*next_pipeB1[3:0])|8'b0,4'b0} + sum1;
	next_pipeA2 <= next_pipeA1;
	next_pipeB2 <= next_pipeB1;
end

always @(sum2)
begin
	@(posedge clk)
	sum3 <= {4'b0,(next_pipeA2[3:0]*next_pipeB2[7:4])|8'b0,4'b0} + sum2;
	next_pipeA3 <= next_pipeA2;
	next_pipeB3 <= next_pipeB2;
end

always @(sum3)
begin
	@(posedge clk)
	product <= {(next_pipeA3[7:4] * next_pipeB3[7:4])|8'b0,8'b0} + sum3;
end

endmodule