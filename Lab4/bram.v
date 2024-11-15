module bram
	#(
		parameter RAM_WIDTH 		= 32,
		parameter RAM_ADDR_BITS 	= 9,
		parameter DATA_FILE 		= "data_file.txt",
		parameter INIT_START_ADDR 	= 0,
		parameter INIT_END_ADDR		= 10
	)
	(
	input							clock,
	input							ram_enable,
	input							write_enable,
    input 		[RAM_ADDR_BITS-1:0]	address,
    input 		[RAM_WIDTH-1:0] 	input_data,
	output reg 	[RAM_WIDTH-1:0] 	output_data
	);
	
   
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name [(2**RAM_ADDR_BITS)-1:0];


   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   initial
      $readmemh(DATA_FILE, ram_name, INIT_START_ADDR, INIT_END_ADDR);

   always @(posedge clock)
      if (ram_enable) begin
         if (write_enable)
            ram_name[address] <= input_data;
         output_data <= ram_name[address];
      end

endmodule


//testbench
module tb_bram;

parameter RAM_WIDTH = 32;
parameter RAM_ADDR_BITS = 9;

reg							clk;
reg							ram_enable;
reg							write_enable;
reg 	[RAM_ADDR_BITS-1:0]	address;
reg 	[RAM_WIDTH-1:0] 	input_data;
wire	[RAM_WIDTH-1:0] 	output_data;

bram
#(
	.RAM_WIDTH 		(RAM_WIDTH 		),
	.RAM_ADDR_BITS 	(RAM_ADDR_BITS 	),
	.DATA_FILE 		("data_file.txt"),
	.INIT_START_ADDR(0				),
	.INIT_END_ADDR	(10				)
)
bram_inst
(
	.clock			(clk			),
	.ram_enable		(ram_enable		),
	.write_enable	(write_enable	),
	.address		(address		),
	.input_data		(input_data		),
	.output_data    (output_data	)
);
	
initial
begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_bram);
	
	ram_enable		= 1;
	write_enable	= 0;
	address			= 0;
	input_data		= 0;

	repeat(2) @(posedge clk);


	$display("Writing data in BRAM");
	#1	write_enable	= 1;
	for (address = 0; address < 20; address = address +1)
	begin
		input_data = address*10;
		@(posedge clk);
		#1;
	end
	write_enable	= 0;

	$display("Reading data from BRAM");
	repeat(2) @(posedge clk);
	for (address = 0; address < 20; address = address +1)
	begin
		@(posedge clk);
		#1 $display ("ADDR: %d, DATA: %d", address, output_data);
	end
	
	repeat(2) @(posedge clk);
	$finish;
end

endmodule
						