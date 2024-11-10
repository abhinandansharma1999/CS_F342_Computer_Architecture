module palin_moore_3bit_OL
	#(parameter state_width = 4)
				
	(input serial_in,
	 input clk,
	 input rst,
	 output reg out);
 
reg [(state_width-1):0] current_state, next_state;

always@(*)
begin
case (current_state)
	4'b0000	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0001;
				else 
					next_state = 4'b0110;
				end

	4'b0001	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0010;
				else 
					next_state = 4'b0100;
				end
				
	4'b0010	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0011;
				else 
					next_state = 4'b0100;
				end

	4'b0011	:	begin
				out = 1'b1;
				if (serial_in == 1'b0) 
					next_state = 4'b0011;
				else 
					next_state = 4'b0100;
				end				

	4'b0100	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0101;
				else 
					next_state = 4'b1001;
				end

	4'b0101	:	begin
				out = 1'b1;
				if (serial_in == 1'b0) 
					next_state = 4'b0010;
				else 
					next_state = 4'b1000;
				end

	4'b0110	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0111;
				else 
					next_state = 4'b1001;
				end

	4'b0111	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0010;
				else 
					next_state = 4'b1000;
				end

	4'b1000	:	begin
				out = 1'b1;
				if (serial_in == 1'b0) 
					next_state = 4'b0101;
				else 
					next_state = 4'b1001;
				end

	4'b1001	:	begin
				out = 1'b0;
				if (serial_in == 1'b0) 
					next_state = 4'b0111;
				else 
					next_state = 4'b1010;
				end

	4'b1010	:	begin
				out = 1'b1;
				if (serial_in == 1'b0) 
					next_state = 4'b0111;
				else 
					next_state = 4'b1010;
				end				
				
	default	:	begin
				out = 1'b0;
				next_state = 4'b0000;
				end
				
endcase
end

always@(posedge clk)
begin

if (rst) begin
	current_state = 4'b0000;
end

else begin
	current_state = next_state;
end

end
endmodule


//testbench
module tb_palin_moore_3bit_OL ();
reg serial_in, clk, rst;
wire out;

parameter T = 20;

palin_moore_3bit_OL uut (.serial_in(serial_in), .clk(clk), .rst(rst), .out(out));

initial
begin
rst = 1'b0;
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin
$monitor ($time, "serial_in = %b	out = %b", serial_in, out);
#(20*T) rst = 1'b1;
#(2*T) rst = 1'b0;
#(20*T) $finish;
end

initial
begin
serial_in = 1'b0;
forever #(T) serial_in = $random;
end

endmodule