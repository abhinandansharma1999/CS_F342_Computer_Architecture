// Tanvi Shewale 2018A3PS0298P
// Abhinandan Sharma 2018A3PS0095P

module division (FLAG, qnt, rem, inA, inB, CLOCK, RESET, LOAD);

input CLOCK, RESET, LOAD ;
input [15:0]inA ;
input [7:0]inB;
output reg [2:0] FLAG;
output reg [15:0] qnt; 
output reg [7:0]rem; 

wire spcase1, spcase2,spcase3,spcase4,spcase5;
reg [15:0] count;
reg [15:0] diff;

assign spcase1 = ~|inB;
assign spcase2 = ~(~inB[0] | inB[1] | inB[2] | inB[3] | inB[4] | inB[5] | inB[6] | inB[7]);
assign spcase3 = ~((inB[0] | ~inB[1] | inB[2] | inB[3] | inB[4] | inB[5] | inB[6] | inB[7] ) &
				   (inB[0] | inB[1] | ~inB[2] | inB[3] | inB[4] | inB[5] | inB[6] | inB[7] ) &
				   (inB[0] | inB[1] | inB[2] | ~inB[3] | inB[4] | inB[5] | inB[6] | inB[7] ) &
				   (inB[0] | inB[1] | inB[2] | inB[3] | ~inB[4] | inB[5] | inB[6] | inB[7] ) &
				   (inB[0] | inB[1] | inB[2] | inB[3] | inB[4] | ~inB[5] | inB[6] | inB[7] ) &
				   (inB[0] | inB[1] | inB[2] | inB[3] | inB[4] | inB[5] | ~inB[6] | inB[7] ) &
				   (inB[0] | inB[1] | inB[2] | inB[3] | inB[4] | inB[5] | inB[6] | ~inB[7] ) ) &
				   (~spcase5);
				   				  
assign spcase4 = ~(((|(inA[15:8] ^ inB )) | inA[7] | inA[6] | inA[5] | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]) &	
                    (inA[15] | (|(inA[14:7] ^ inB )) | inA[6] | inA[5] | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]) &				  
		            (inA[15] | inA[14] | (|(inA[13:6] ^ inB )) | inA[5] | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]) &
					(inA[15] | inA[14] | inA[13] | (|(inA[12:5] ^ inB )) | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]) &
					(inA[15] | inA[14] | inA[13] | inA[12] | (|(inA[11:4] ^ inB )) | inA[3] | inA[2] | inA[1] | inA[0]) &
					(inA[15] | inA[14] | inA[13] | inA[12] | inA[11] | (|(inA[10:3] ^ inB )) | inA[2] | inA[1] | inA[0]) &
					(inA[15] | inA[14] | inA[13] | inA[12] | inA[11]  | inA[10] | (|(inA[9:2] ^ inB )) | inA[1] | inA[0]) &
					(inA[15] | inA[14] | inA[13] | inA[12] | inA[11]  | inA[10] | inA[9] | (|(inA[8:1] ^ inB )) | inA[0])) &
//					(inA[15] | inA[14] | inA[13] | inA[12] | inA[11]  | inA[10] | inA[9] | inA[8] | (|(inA[7:0] ^ inB )))) & 
					(~spcase1) &
					(~spcase2);
					
assign spcase5 = ((inA[7:0] < {8'd0, inB})	? 1'b1 : 1'b0) & ~spcase2;	

always @ (RESET, posedge CLOCK)
begin
	if(RESET == 1'b1)
		begin
			FLAG = 3'b000; 
			rem = 8'd0;
			qnt = 16'd0;
		end
		
	else  
	begin
		case ({spcase1, spcase2, spcase3, spcase4, spcase5})
			5'b10000	:	begin 
								qnt = 16'b11111111_11111111;
								rem = 8'b11111111;
								FLAG = 3'b011;
							end
			5'b01000	:	begin
								qnt = inA;
								rem = 8'd0;
								FLAG = 3'b100;
							end
			5'b00100	:	begin
								if (inB == 8'b10000000)
								begin
									qnt <= {7'd0, inA[15:7]};
									rem <= {1'd0, inA[6:0]};
								end
								else if (inB == 8'b01000000)
								begin
									qnt <= {6'd0, inA[15:6]};
									rem <= {2'd0, inA[5:0]};
								end
								else if (inB == 8'b00100000)
								begin
									qnt <= {5'd0, inA[15:5]};
									rem <= {3'd0, inA[4:0]};
								end
								else if (inB == 8'b00010000)
								begin
									qnt <= {4'd0, inA[15:4]};
									rem <= {4'd0, inA[3:0]};
								end
								else if (inB == 8'b00001000)
								begin
									qnt <= {3'd0, inA[15:3]};
									rem <= {5'd0, inA[2:0]};
								end
								else if (inB == 8'b00000100)
								begin
									qnt <= {2'd0, inA[15:2]};
									rem <= {6'd0, inA[1:0]};
								end
								else if (inB == 8'b00000010)
								begin
									qnt <= {1'b0, inA[15:1]};
									rem <= {7'd0, inA[0]};
								end
								// else
								// begin
									// qnt <= 16'dz;
									// rem <= 8'dz;
								// end

								FLAG = 3'b101;	
							end
			5'b00010   :	begin 
								if (~((|(inA[15:8] ^ inB )) | inA[7] | inA[6] | inA[5] | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]))
									qnt <= 16'b00000001_00000000;
								else if (~(inA[15] | (|(inA[14:7] ^ inB )) | inA[6] | inA[5] | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]))
									qnt <= 16'b00000000_10000000;
								else if (~(inA[15] | inA[14] | (|(inA[13:6] ^ inB )) | inA[5] | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]))	
									qnt <= 16'b00000000_01000000;
								else if (~(inA[15] | inA[14] | inA[13] | (|(inA[12:5] ^ inB )) | inA[4] | inA[3] | inA[2] | inA[1] | inA[0]))
									qnt <= 16'b00000000_00100000;
								else if (~(inA[15] | inA[14] | inA[13] | inA[12] | (|(inA[11:4] ^ inB )) | inA[3] | inA[2] | inA[1] | inA[0]))
									qnt <= 16'b00000000_00010000;
								else if (~(inA[15] | inA[14] | inA[13] | inA[12] | inA[11] | (|(inA[10:3] ^ inB )) | inA[2] | inA[1] | inA[0]))
									qnt <= 16'b00000000_00001000;
								else if (~(inA[15] | inA[14] | inA[13] | inA[12] | inA[11]  | inA[10] | (|(inA[9:2] ^ inB )) | inA[1] | inA[0]))
									qnt <= 16'b00000000_00000100;
								else if (~(inA[15] | inA[14] | inA[13] | inA[12] | inA[11]  | inA[10] | inA[9] | (|(inA[8:1] ^ inB )) | inA[0]))	
									qnt <= 16'b00000000_00000010;
								else if (~(inA[15] | inA[14] | inA[13] | inA[12] | inA[11]  | inA[10] | inA[9] | inA[8] | (|(inA[7:0] ^ inB ))))
									qnt <= 16'b00000000_00000001;
								// else 
									// qnt <= 16'dz;
								rem <= 8'b0;
								FLAG <= 3'b110;
							end	
			5'b00001	:	begin
								qnt = 16'd0;
								rem = inA[7:0];
								FLAG = 3'b111;
							end
			5'b00000	:	begin
								FLAG = 3'b001;
								diff = diff - {8'd0,inB};
								count = count + 16'd1;
								if (diff < inB)
								begin 
									qnt = count;
									rem = diff;
									FLAG = 3'b010;
								end
							end
			default 	:	begin 
								qnt = 16'dz;
								rem = 8'dz;
								FLAG = 3'dz;
							end	
		endcase
	end	
end	

always @(posedge CLOCK)
begin
	if(LOAD == 1'b1)
	begin
		diff = inA;
		count = 16'd0;		
	end
end			

endmodule

/*************************************************************************************************************************************/

module tb_division();

reg CLOCK, RESET, LOAD ;
reg [15:0] inA;
reg [7:0] inB;
wire [2:0] FLAG;
wire [15:0] qnt;
wire [7:0] rem;


division uut (FLAG, qnt, rem, inA, inB, CLOCK, RESET, LOAD);

initial 
begin
CLOCK = 1'b1;	
end

always #5 CLOCK = ~CLOCK;

initial 
begin
	$monitor ("inA = %b	inB = %b	RESET = %b	LOAD = %b	qnt = %b	rem = %b	FLAG = %b", inA, inB, RESET, LOAD, qnt, rem, FLAG);
	$dumpfile("division.vcd");
	$dumpvars(0,tb_division);
	
	RESET = 1'b1;
	#10
	RESET = 1'b0;
	inA = 16'd10;
	inB = 8'd0;
	LOAD = 1'b1;
	#25
	LOAD = 1'b0;
	#15
	inA = 16'd10;
	inB = 8'd1;
	LOAD = 1'b1;
	#25
	LOAD = 1'b0;
	#15
	inA = 16'd10;
	inB = 8'd8;
	LOAD = 1'b1;
	#25
	LOAD = 1'b0;
	#15
	inA = 16'b00000111_11000000;
	inB = 8'b00111110;
	LOAD = 1'b1;
	#25
	LOAD = 1'b0;
	#15
	inA = 16'd9;
	inB = 8'd15;
	LOAD = 1'b1;
	#25
	LOAD = 1'b0;
	#15
	inA = 16'd50;
	inB = 8'd50;
	LOAD = 1'b1;
	#25
	LOAD = 1'b0;
	#15
	// inA = 16'b11111111_11111111;
	// inB = 8'd3;
	// LOAD = 1'b1;
	// #25
	// LOAD = 1'b0;
	// #437000
	inA = 16'd50;
	inB = 8'd21;
	LOAD = 1'b1;
	#25	
	LOAD = 1'b0;
	#15
	inA = 16'd250;
	inB = 8'd17;
	LOAD = 1'b1;
	#15
	LOAD = 1'b0;
	#150
	$finish;
	
end
endmodule	
