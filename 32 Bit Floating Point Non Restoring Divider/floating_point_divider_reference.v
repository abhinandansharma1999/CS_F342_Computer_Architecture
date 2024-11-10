//Only While and Repeat loops are used
//While loops are used just for conditional shift purposes, they can be easily realised by a shift register with shift port having basic combinational logic
//Repeat loop is used to perform the Non-restoring algorithm for 47 times, it can be easily realised by a mod47 counter
//QNaN and SNaN are considered as invalid oprands, while zero by zero is put under divide by zero exception.


module fpdiv (AbyB, DONE, EXCEPTION, InputA, InputB, CLOCK, RESET);

input CLOCK,RESET ; // Active High Synchronous Reset
input [31:0] InputA,InputB ;
output reg [31:0] AbyB;
output reg DONE ; // ‘0’ while calculating, ‘1’ when the result is ready
output reg [1:0] EXCEPTION; // Used to output exceptions

reg [23:0] mentissaA, mentissaB, temp_output;
reg [25:0] A;
reg [9:0] exponentA, exponentB, N, Exponent_decision,shift;
reg [7:0] temp_exponent;

always @(InputA or InputB or RESET)
begin
	if(InputB[30:0] == 31'h0) //Divide by Zero Exception
	begin
		EXCEPTION = 2'b00;
		AbyB = {{InputA[31]^InputB[31]},31'h7FFFFFFF};
		DONE = 1'b1;
	end
	
	else if(InputB[30:0] == 31'h7F880000 | InputB[30:0] == 31'h7FC00200 | InputA[30:0] == 31'h7F880000 | InputA[30:0] == 31'h7FC00200 | InputA[30:0] == 31'h7FFFFFFF | InputB[30:0] == 31'h7FFFFFFF) //QNaN SNaN Exception, Invalid Oprands
	begin
		EXCEPTION = 2'b11;
		AbyB = 32'h0;
		DONE = 1'b1;
	end
	
	else if(RESET) //Reset condition
		AbyB = 32'h0;
		
	else if (InputA[30:0] == 31'h0)
	begin
		AbyB = {InputA[31]^InputB[31],31'h0};
		DONE = 1'b1;
	end
		
	else //Main Division Block
	begin
		DONE = 1'b0;
		N = 10'h0; //keeps track of Exponent deviation
		A = 26'h0; //used in non restoring algorithm to decide operation and quotient
		EXCEPTION = 2'bxx;
		
		//Assigning exponents and mentissa according to subnormal or normal format, calculating sign bit
		exponentA = {2'b00,InputA[30:23]};
		exponentB = {2'b00,InputB[30:23]};
		if(exponentA == 8'h00)
			mentissaA = {InputA[22:0],1'b0};
		else
			mentissaA = {1'b1,InputA[22:0]};
		if(exponentB == 8'h00)
			mentissaB = {InputB[22:0],1'b0};
		else
			mentissaB = {1'b1,InputB[22:0]};	
		AbyB[31] = InputA[31]^InputB[31];
		
		// Shifting in case of subnormal numbers, aligning to first bit
		while(~(mentissaA[23] & mentissaB[23]))
		begin
			@(posedge CLOCK)
			if(~mentissaA[23])
			begin
				mentissaA = mentissaA << 1;
				N=N - 1'b1;
			end
			if(~mentissaB[23])
			begin
				mentissaB = mentissaB << 1;
				N=N + 1'b1;
			end
		end
		
		
		//non restoring Algorithm performed
		@(posedge CLOCK)
			A = {A[24:0],mentissaA[23]};
			A = A - mentissaB;
		repeat(47)//performed 47 times to get most precise quotient possible
		begin
			@(posedge CLOCK)
			if(A[25])
			begin
				mentissaA = mentissaA<<1;
				A = {A[24:0],mentissaA[23]};
				if(A[25])
					A = A + mentissaB;
				else
					A = A - mentissaB;
			end
			else
			begin
				mentissaA = {mentissaA[22:0],1'b1};
				A = {A[24:0],mentissaA[23]};
				if(A[25])
					A = A + mentissaB;
				else
					A = A - mentissaB;
			end
		end
		
		//post algorithm shifting to align the output
		temp_output = mentissaA[23:0];
		if(~temp_output[23])
		begin
			@(posedge CLOCK)
			temp_output = temp_output << 1;
			N = N - 1'b1;
		end
		
		//pre calculation to classify result among extreme cases, normal cases and subnormal cases
		Exponent_decision = exponentA - exponentB + N;	
		temp_exponent = Exponent_decision[7:0] + 8'h7F;
		AbyB[30:0] = {temp_exponent,temp_output[22:0]}; 
		shift = 10'h382 - Exponent_decision;
		
		//UnderFlow
		if(shift[8:0]>5'h18 & ~shift[9])
		begin
			EXCEPTION = 2'b01;
			AbyB[30:0] = 31'h0;
		end
		
		//Subnormal answer case
		else if(~shift[9]) 
		begin
			while(~shift[9])
			begin
				@(posedge CLOCK)
				temp_output = temp_output>>1;
				shift = shift - 1'b1;
			end	
			AbyB[30:0] = {8'h0,temp_output[22:0]};
		end
		
		//OverFlow
		if(Exponent_decision[8:7]>2'b00 & ~Exponent_decision[9])
		begin
			EXCEPTION = 2'b10;
			//AbyB = Exponent_decision;
			AbyB[30:0] = {8'hFF,23'h7FFFFF}; 
		end
		DONE = 1'b1;
	end
end

endmodule