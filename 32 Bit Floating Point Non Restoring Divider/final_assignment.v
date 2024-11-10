module final_assignment(AbyB, DONE, EXCEPTION, CLOCK, RESET, exceptions_A, exceptions_B, AbyB_valid, AbyB_under, AbyB_over);
input [4:0] exceptions_A;
input [4:0] exceptions_B;
input [31:0] AbyB_valid;
input RESET;
input CLOCK;
input AbyB_under;
input AbyB_over;
output reg [31:0] AbyB;
output reg DONE;
output reg [1:0] EXCEPTION;

// exceptions_A = {A_inf, A_zero, A_nan, A_subnormal, A_dividend}

always @ (posedge CLOCK)
	begin
		DONE = 1'b0;
		
		if (RESET)
		begin
		AbyB = 32'd0;
		end
		
		else
		begin
		casez({exceptions_A, exceptions_B, AbyB_valid[31], AbyB_under, AbyB_over})
		13'b1????_1????_??? :	begin 
								AbyB = 32'b11111111111111111111111111111111; //inf/inf
								EXCEPTION = 2'b11;
								end
		13'b10000_00001_1?? : 	begin 
								AbyB = 32'b11111111100000000000000000000000; //inf/n
								EXCEPTION = 2'b11;
								end	
		13'b1????_????1_0?? : 	begin 
								AbyB = 32'b01111111100000000000000000000000; //inf/n
								EXCEPTION = 2'b11;
								end
		13'b????1_1????_1?? : 	begin 
								AbyB = 32'b10000000000000000000000000000000; //n/inf
								EXCEPTION = 2'b11;
								end
		13'b????1_1????_0?? : 	begin 
								AbyB = 32'b00000000000000000000000000000000; //n/inf
								EXCEPTION = 2'b11;
								end
		13'b1????_?1???_1?? : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //inf/0
								EXCEPTION = 2'b11;
								end	
		13'b1????_?1???_0?? : 	begin 
								AbyB = 32'b01111111100000000000000000000000;  //inf/0
								EXCEPTION = 2'b11;
								end
		13'b?1???_1????_1?? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //0/inf
								EXCEPTION = 2'b11;
								end
		13'b?1???_1????_0?? :	begin 
								AbyB = 32'b00000000000000000000000000000000;  //0/inf
								EXCEPTION = 2'b11;
								end
		13'b?1???_?1???_??? : 	begin 
								AbyB = 32'b11111111111111111111111111111111;  //0/0
								EXCEPTION = 2'b00;
								end
		13'b????1_?1???_1?? : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //n/0
								EXCEPTION = 2'b00;
								end
		13'b????1_?1???_0?? : 	begin 
								AbyB = 32'b01111111100000000000000000000000;  //n/0
								EXCEPTION = 2'b00;
								end
		13'b??1??_?????_??? : 	begin 
								AbyB = 32'b11111111111111111111111111111111;  //A is Nan
								EXCEPTION = 2'b11;
								end
		13'b?????_??1??_??? : 	begin 
								AbyB = 32'b11111111111111111111111111111111;  //B is Nan
								EXCEPTION = 2'b11;
								end
		13'b?1???_????1_1?? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //0/n
								EXCEPTION = 2'bzz;
								end
		13'b?1???_????1_0?? : 	begin 
								AbyB = 32'b00000000000000000000000000000000;  //0/n
								EXCEPTION = 2'bzz;
								end
		13'b????1_????1_?00 : 	begin              //n/n
								AbyB = AbyB_valid;
								EXCEPTION = 2'bzz;
								end
		13'b????1_???1?_?00 : 	begin              //n/sub
								AbyB = AbyB_valid;
								EXCEPTION = 2'bzz;
								end
		13'b???1?_????1_?00 : 	begin              //sub/n
								AbyB = AbyB_valid;
								EXCEPTION = 2'bzz;
								end
		13'b???1?_???1?_?00 : 	begin              //sub/sub
								AbyB = AbyB_valid;
								EXCEPTION = 2'bzz;
								end	
								
		13'b????1_????1_01? : 	begin 
								AbyB = 32'b00000000000000000000000000000000;  //underflow n/n
								EXCEPTION = 2'b01;
								end	
		13'b????1_???1?_01? : 	begin 
								AbyB = 32'b00000000000000000000000000000000;  //underflow n/sub
								EXCEPTION = 2'b01;
								end	
		13'b???1?_????1_01? : 	begin 
								AbyB = 32'b00000000000000000000000000000000;  //underflow sub/n
								EXCEPTION = 2'b01;
								end	
		13'b???1?_???1?_01? : 	begin 
								AbyB = 32'b00000000000000000000000000000000;  //underflow sub/sub
								EXCEPTION = 2'b01;
								end	

		13'b????1_????1_11? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //underflow n/n
								EXCEPTION = 2'b01;
								end	
		13'b????1_???1?_11? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //underflow n/sub
								EXCEPTION = 2'b01;
								end	
		13'b???1?_????1_11? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //underflow sub/n
								EXCEPTION = 2'b01;
								end	
		13'b???1?_???1?_11? : 	begin 
								AbyB = 32'b10000000000000000000000000000000;  //underflow sub/sub
								EXCEPTION = 2'b01;
								end									
															
		13'b????1_????1_0?1 : 	begin 
								AbyB = AbyB_valid;  //overflow n/n
								EXCEPTION = 2'b10;
								end
		13'b????1_???1?_0?1 : 	begin 
								AbyB = AbyB_valid;  //overflow n/sub
								EXCEPTION = 2'b10;
								end
		13'b???1?_????1_0?1 : 	begin 
								AbyB = AbyB_valid;  //overflow sub/n
								EXCEPTION = 2'b10;
								end
		13'b???1?_???1?_0?1 : 	begin 
								AbyB = AbyB_valid;  //overflow sub / sub
								EXCEPTION = 2'b10;
								end								
								
		13'b????1_????1_1?1 : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //overflow n/n
								EXCEPTION = 2'b10;
								end
		13'b????1_???1?_1?1 : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //overflow n/sub
								EXCEPTION = 2'b10;
								end
		13'b???1?_????1_1?1 : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //overflow sub/n
								EXCEPTION = 2'b10;
								end
		13'b???1?_???1?_1?1 : 	begin 
								AbyB = 32'b11111111100000000000000000000000;  //overflow sub/sub
								EXCEPTION = 2'b10;
								end
								
 		default				:	begin 
								AbyB = 32'bz;
								EXCEPTION = 2'bzz;
								end				
						  
		endcase
		end
		
		DONE = 1'b1;	
	end
endmodule