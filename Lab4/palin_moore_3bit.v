module palin_moore_3bit (clk, rst,serial_in, out);
input clk, rst,serial_in;
output out;
reg [4:0] current_state;
reg [4:0] next_state;
reg out;

always @(posedge clk)
begin
 if(rst == 1) 
 current_state <= 4'b0000;
 else
 current_state <= next_state; 
end

always @(*)
begin
	case(current_state) 
		4'b0000:begin
				out = 0;
				if(serial_in==1)
				next_state = 4'b0011;
				else
				next_state = 4'b0010;
				end
		4'b0001:begin
				out = 0;
				if(serial_in==1)
				next_state = 4'b0101;
				else
				next_state = 4'b0100;
				end	
		4'b0010:begin
				out = 0;
				if(serial_in==1)
				next_state = 4'b0011;
				else
				next_state = 4'b0110;
				end			
		4'b0011:begin
				out = 0;
				if(serial_in==1)
				next_state = 4'b0101;
				else
				next_state = 4'b0111;
				end
		4'b0100:begin
				out = 0;
				if(serial_in==1)
				next_state = 4'b1000;
				else
				next_state = 4'b0010;
				end	
		4'b0101:begin
				out = 0;
				if(serial_in==1)
				next_state = 4'b1001;
				else
				next_state = 4'b0100;
				end	
		4'b0110:begin
				out = 1;
				if(serial_in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end	
		4'b0111:begin
				out = 1;
				if(serial_in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end	
		4'b1000:begin
				out = 1;
				if(serial_in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end	
		4'b1001:begin
				out = 1;
				if(serial_in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end			
 default:next_state = 4'b0000;
 endcase
end

endmodule


//testbench
module tb_palin_moore_3bit ();
reg serial_in, clk, rst;
wire out;

parameter T = 20;

palin_moore_3bit uut (.serial_in(serial_in), .clk(clk), .rst(rst), .out(out));

initial
begin
rst = 1'b0;
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin
$monitor ($time, "serial_in = %b	out = %b", serial_in, out);
#(20*T) $finish;
end

initial
begin
serial_in = 1'b0;
forever #(T) serial_in = $random;
end

endmodule