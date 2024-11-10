module palin_mealy_3bit_OL
	#(parameter state_width = 3)
				
	(input serial_in,
	 input clk,
	 input rst,
	 output reg out);
 
reg [(state_width-1):0] current_state;
 
always@(posedge clk)
begin

if (rst) begin
	current_state = 3'b000;
	out = 1'b0;
end

else begin
    case (current_state)
    	3'b000	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b001;
    					out = 1'b0;
    				end
    				else begin
    					current_state = 3'b010;
    					out = 1'b0;
    				end
    				end
    				
    	3'b001	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b011;
    					out = 1'b0;
    				end
    				else begin
    					current_state = 3'b100;
    					out = 1'b0;
    				end
    				end
    				
    	3'b010	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b101;
    					out = 1'b0;
    				end
    				else begin
    					current_state = 3'b110;
    					out = 1'b0;
    				end
    				end
    
    	3'b011	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b011;
    					out = 1'b1;
    				end
    				else begin
    					current_state = 3'b100;
    					out = 1'b0;
    				end
    				end
    				
    	3'b100	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b101;
    					out = 1'b1;
    				end
    				else begin
    					current_state = 3'b110;
    					out = 1'b0;
    				end
    				end
    			
    	3'b101	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b011;
    					out = 1'b0;
    				end
    				else begin
    					current_state = 3'b100;
    					out = 1'b1;
    				end	
    				end
    
    	3'b110	:	begin
    	            if (serial_in == 1'b0) begin
    					current_state = 3'b101;
    					out = 1'b0;
    				end
    				else begin
    					current_state = 3'b110;
    					out = 1'b1;
    				end	
    				end
    				
    	default	:	begin
    				current_state = 3'b000;
    				out = 1'b0;
    				end
    endcase
end
end

endmodule


//testbench
module tb_palin_mealy_3bit_OL ();
reg serial_in, clk, rst;
wire out;

parameter T = 20;

palin_mealy_3bit_OL uut (.serial_in(serial_in), .clk(clk), .rst(rst), .out(out));

initial
begin
rst = 1'b0;
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin
$monitor ($time, "serial_in = %b	serial_out = %b", serial_in, out);
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



