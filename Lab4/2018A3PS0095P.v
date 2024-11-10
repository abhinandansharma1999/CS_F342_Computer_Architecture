// Name: ABHINANDAN SHARMA
// ID  : 2018A3PS0095P
// Lab : 4
//********************************Q1***************************************************************

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

//********************************Q2***************************************************************

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

//********************************Q3***************************************************************

module memory_64byte (dout, address, din, wen, ren, clk);
output reg [7:0] dout;
input [7:0] din;
input [5:0] address;
input wen, ren, clk;
reg [7:0] mem [0:63];

initial
	$readmemb("dummy.txt", mem);
	
always @(negedge clk)
begin
	if(wen) begin
		mem[address] <= din;
		$writememh("gray.txt", mem);
	end
end
 
always @(ren, address)
begin
	if(ren)
		dout <= mem[address];
	else
		dout <= 8'bz;
end

endmodule

module bin_to_gray (out_gray, in_binary);
output[7:0] out_gray;
input[7:0] in_binary;

assign out_gray[0] = in_binary[0] ^ in_binary[1];
assign out_gray[1] = in_binary[1] ^ in_binary[2];
assign out_gray[2] = in_binary[2] ^ in_binary[3];
assign out_gray[3] = in_binary[3] ^ in_binary[4];
assign out_gray[4] = in_binary[4] ^ in_binary[5];
assign out_gray[5] = in_binary[5] ^ in_binary[6];
assign out_gray[6] = in_binary[6] ^ in_binary[7];
assign out_gray[7] = in_binary[7];

endmodule


//testbench
module tb_memory_64byte;
wire [7:0] dout, gray;
reg [7:0] din, binary;
reg [5:0] address;
reg wen, ren, clk;

parameter T = 10;

memory_64byte uut1 (.dout(dout), .address(address), .din(din), .wen(wen), .ren(ren), .clk(clk));
bin_to_gray uut2 (.out_gray(gray), .in_binary(binary));

initial
begin
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin

$dumpfile("wave.vcd");
$dumpvars(0, tb_memory_64byte);

#1;
address = 6'b0;
ren = 1'b1;
wen = 1'b1;

repeat(64)
begin
	#1 $display("binary data = %h at address = %h",dout,address);
	binary = dout;
	#1 din = gray;
	#8 address = address +1'b1;
end

#10
wen = 1'b0;

repeat(64)
begin
	#1 $display("gray data = %h at address = %h",dout,address);
	#1 address = address + 1'b1;
end

$finish;

end
endmodule