module BCD_multiplier (PQRS, JKH, LMH);
input [7:0] JKH, LMH;
output [15:0] PQRS;

wire [6:0] JKH_bin, LMH_bin;
wire [13:0] PQRS_bin;

assign JKH_bin = JKH[7:4] * 4'b1010 + JKH[3:0];
assign LMH_bin = LMH[7:4] * 4'b1010 + LMH[3:0];

assign PQRS_bin = JKH_bin * LMH_bin;

assign PQRS[3:0] = PQRS_bin % 10;
assign PQRS[7:4] = ((PQRS_bin - (PQRS_bin % 10)) % 100) / 10;
assign PQRS[11:8] = ((PQRS_bin - (PQRS_bin % 100)) % 1000) / 100;
assign PQRS[15:12] = (PQRS_bin - (PQRS_bin % 1000)) / 1000;

endmodule


//Testbench
module tb_BCD_multiplier ();
reg [7:0] JKH, LMH; 
wire[15:0] PQRS;

BCD_multiplier uut(.PQRS(PQRS), .JKH(JKH), .LMH(LMH));

initial begin
$monitor("JKH = %b	LMH = %b	PQRS = %h", JKH, LMH, PQRS);

JKH = 8'b00000000;	//00
LMH = 8'b00000000;	//00
#1
JKH = 8'b10011001;	//99
LMH = 8'b10011001;	//99
#1
JKH = 8'b10001000;	//88
LMH = 8'b01110111;	//77
#1
JKH = 8'b10000000;	//80
LMH = 8'b01010101;	//55
#1
JKH = 8'b00111001;	//39
LMH = 8'b00100111;	//27
#1
JKH = 8'b10010000;	//90
LMH = 8'b01010101;	//55

end
endmodule