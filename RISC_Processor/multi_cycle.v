// Ansh Shah (2018A3PS0294P)
// Abhinandan Sharma (2018A3PS0095P)
// Tanvi Shewale (2018A3PS0298P)


//*********************************************************************************************************************************************************
//testbench
`timescale 1ns/1ps 
module tb_multi_cycle ();
reg clk, rst;
reg [15:0] PC_init;

wire error_log_1, error_log_2, error_log_3;

//Control signals
wire IR_write, PC_write_cond, PC_write, mem_read, mem_write, mem_to_reg, reg_write;
wire [1:0] PC_src;
wire [2:0] ALU_src_A, ALU_src_B;
wire [15:0] PC;
wire [3:0] stage;

parameter T = 10;

multi_cycle uut (rst, PC_init, clk, error_log_1, error_log_2, error_log_3,
	IR_write, PC_write_cond, PC_write, mem_read, mem_write, mem_to_reg, reg_write,
	PC_src, ALU_src_A, ALU_src_B, PC, stage);

initial
begin
	clk = 1'b0;
	#(T/2)
	forever #(T/2) clk = ~clk;
end

always@(posedge error_log_1)
begin
	$display ("ERROR_1 : Contents of R0 cannot be modified");
	$finish;
end

always@(posedge error_log_2)
begin
	$display ("ERROR_2 : Invalid function field for shift operation");
	$finish;
end

always@(posedge error_log_3)
begin
	$display ("ERROR_3 : Cannot branch/ jump to an odd address in instruction memory");
	$finish;
end

initial
begin
	forever
	begin
		#(T)
		$display ($time);
		$display ("stage			=		%d", stage);	//Refer the control unit FSM to determine the stage (IF, ID, EX, MEM, WB)
		$display ("PC			=		%hH", PC);
		$display ("PC_write		=		%b", PC_write);
		$display ("IR_write		=		%b", IR_write);
		$display ("ALU_src_A		=		%b", ALU_src_A);
		$display ("ALU_src_B		=		%b", ALU_src_B);
		$display ("PC_src			=		%b", PC_src);
		$display ("reg_write		=		%b", reg_write);
		$display ("PC_write_cond		=		%b", PC_write_cond);
		$display ("mem_to_reg		=		%b", mem_to_reg);
		$display ("mem_read		=		%b", mem_read);
		$display ("mem_write		=		%b", mem_write);
		$display ("");
	end
end

initial
begin
	$dumpfile("multi_cycle.vcd");
	$dumpvars(0, tb_multi_cycle);

	rst = 1'b1;			
	PC_init = 16'd0;	// Change this to the address from where the fetching needs to be started
	#(T/4)
	rst = 1'b0;
	#(159*T) $finish;	// Change this based on the time the instructions will require to get executed
end
	
endmodule
	

//****************************************************************************************************************************************************

module multi_cycle (rst, PC_init, clk, error_log_1, error_log_2, error_log_3,
		IR_write, PC_write_cond, PC_write, mem_read, mem_write, mem_to_reg, reg_write,
		PC_src, ALU_src_A, ALU_src_B, PC, stage);
		
input clk, rst;
input [15:0] PC_init;
output error_log_1, error_log_2, error_log_3;

//Control signals
output reg IR_write, PC_write_cond, PC_write, mem_read, mem_write, mem_to_reg, reg_write;
output reg [1:0] PC_src;
output reg [2:0] ALU_src_A, ALU_src_B;
output [15:0] PC;

//Stage counter
output [3:0] stage;

reg [3:0] stage = 4'd0;
reg PC = 16'd0;

//error log
reg error_log_1 = 1'b0;	// error due to write back in R0
reg error_log_2 = 1'b0;	// error due to invalid function field in case of shift instruction
reg error_log_3 = 1'b0;	// error if an attempt is made to branch/ jump to an odd address in ins_mem

//Storage instantiation
reg [7:0] ins_mem [0 : ((2**16) - 1)];
reg [7:0] data_mem [0 : ((2**16) - 1)];
//reg [7:0] ins_mem [0 : 127];		// May use this memory initialization for faster simulation
//reg [7:0] data_mem [0 : 127];		// May use this memory initialization for faster simulation

//PC, Instruction memory and Instruction register i/o
reg [15:0] IR, instr;

//ALU i/o
reg [15:0] ALU_out, ALU_result;
reg zero;
reg [2:0] ALU_ctrl;
reg [15:0] temp1;
reg [15:0] temp2;

//Data memory i/o
reg [15:0] write_data, read_addr, write_addr, MDR;

//Register file i/o
reg [15:0] A, B, C, wd;
reg [3:0] rdr1,rdr2,rdr3,wrr;
reg [15:0] reg_file [0:15];

//Mux outputs
reg [3:0] mux11, mux12, mux13;
reg  mux3; 
reg [15:0] mux21, mux22, mux4, mux5;


//*************************************************************************************************

//Load Register File 
initial                                        
	$readmemh("reg_file.dat",reg_file);

//Load data memory File 
initial
	$readmemh("data_mem.dat",data_mem);

//Load instruction memory File 
initial
	$readmemh("ins_mem.dat",ins_mem);

//*************************************************************************************************

//PC
always@(posedge clk, posedge rst)
begin
	if (rst)
	begin
		PC = PC_init;
		reg_file[0] = 16'd0;
		reg_file[1] = 16'd0;
		reg_file[2] = 16'd0;
		reg_file[3] = 16'd0;
		reg_file[4] = 16'd0;
		reg_file[5] = 16'd0;
		reg_file[6] = 16'd0;
		reg_file[7] = 16'd0;
		reg_file[8] = 16'd0;
		reg_file[9] = 16'd0;
		reg_file[10] = 16'd0;
		reg_file[11] = 16'd0;
		reg_file[12] = 16'd0;
		reg_file[13] = 16'd0;
		reg_file[14] = 16'd0;
		reg_file[15] = 16'd0;
	end	
		
	else if ((mux3 & PC_write_cond) | PC_write)
		PC = mux4;
end

// error_log_3
always@(*)
begin
	if ((PC % 2) == 1'b1)	// odd address found
		error_log_3 = 1'b1;
end
	
//Instruction Memory
always@(*)
begin
	instr = {ins_mem[PC+1], ins_mem[PC]};	//Little Endian
end

//Instruction Register
always@(*)
begin
	if (IR_write)
	begin
		IR = instr;
	end
end

//Mux11, Mux12
always@(*)
begin
	if ((IR[15:12] == 4'b0001) | (IR[15:12] == 4'b0010))
	begin	//reg_src1 = 1 and reg_src2 = 1 and reg_wrr = 1 
		mux11 = {2'b10, IR[9:8]};
		mux12 = {2'b11, IR[11:10]};
		mux13 = {2'b11, IR[11:10]};
	end
	
	else	//reg_src1 = 0 and reg_src2 = 0 and reg_wrr = 0												
	begin
		mux11 = IR[7:4];
		mux12 = IR[3:0];
		mux13 = IR[11:8];
	end
end

//Register File
always@(posedge clk)
begin
	rdr1 = mux11;
	rdr2 = mux12;
	rdr3 = IR[11:8];
	wrr  = mux13;
	
	A = reg_file[rdr1];
	B = reg_file[rdr2];
	C = reg_file[rdr3];
	
	if (reg_write)
	begin
		wd = mux5;
		if (wrr != 4'd0)
		begin
			reg_file[wrr] = wd;
			$writememh("reg_file.dat",reg_file);
		end
		
		else
			error_log_1 = 1'b1;
	end
end

//Mux21
always@(*)
begin
	case(ALU_src_A)
		3'b000	:	mux21 = PC;
		3'b001	:	mux21 = A;
		3'b010	:	mux21 = {{8{IR[7]}}, IR[7:0]};
		3'b011	:	mux21 = {8'd0, IR[7:0]};
		3'b100	:	mux21 = {12'd0, IR[7:4]};
		default	:	mux21 = 16'bx;
	endcase
end

//Mux22
always@(*)
begin
	case(ALU_src_B)
		3'b000	:	mux22 = 16'd2;
		3'b001	:	mux22 = B;
		3'b010	:	mux22 = C;
		3'b011	:	mux22 = {{7{IR[7]}}, IR[7:0], 1'b0};
		3'b100	:	mux22 = {{4{IR[11]}}, IR[11:0]};
		default	:	mux22 = 16'bx;
	endcase
end

//ALU
always@(*)
begin
	temp1 = mux21;
	temp2 = mux22;
	case(ALU_ctrl)
		3'b000	:	ALU_result = mux21 + mux22;
		
		3'b001	: 	begin
						case(IR[15:12] )
							4'b1100	:	begin	//SUB reg
											if (mux21 > mux22)
												ALU_result = mux21 - mux22;
									
											else
											begin
												ALU_result = mux22 - mux21;
												ALU_result = ~(ALU_result) + 16'd1;
											end	
										end
										
							4'b0100	:	ALU_result = mux21 - mux22;		//BE								
							4'b0101	:	ALU_result = mux21 - mux22;		//BNE
							
							4'b1110	:	begin	//SUB imm zero
											if (mux22 > mux21)
												ALU_result = mux22 - mux21;
									
											else
											begin
												ALU_result = mux21 - mux22;
												ALU_result = ~(ALU_result) + 16'd1;
											end	
										end
							4'b1101	:	begin	//SUB imm MSB
											if (mux22 > mux21)
												ALU_result = mux22 - mux21;
									
											else
											begin
												ALU_result = mux21 - mux22;
												ALU_result = ~(ALU_result) + 16'd1;
											end	
										end
							default	:	ALU_result = 16'bx;
						endcase
					end
					
		3'b010	: 	ALU_result = ~(mux21 & mux22);
		3'b011	: 	ALU_result = mux21 | mux22;
		3'b100	: 	begin
						while (temp1 > 0)
						begin
							temp2 = {temp2[14:0],1'b0};
							temp1 = temp1 - 16'd1;
						end
						ALU_result = temp2;
					end
		3'b101	:	begin
						while (temp1 > 0)
						begin
							temp2 = {1'b0,temp2[15:1]};
							temp1 = temp1 - 16'd1;
						end
						ALU_result = temp2;
					end
		3'b110	: 	begin
						while (temp1 > 0)
						begin
							temp2 = {temp2[15],temp2[15:1]};
							temp1 = temp1 - 16'd1;
						end
						ALU_result = temp2;
					end
		default	:	ALU_result = 16'bx;
	endcase
	zero = (ALU_result == 16'd0) ? 1'b1 : 1'b0;
end

//ALU Control
always @(*)
begin
	/*
	add:    000
	sub:    001
	nand:   010
	or:     011
	shift:  100 (left)
	shift:  101 (right logical)
	shift:  110 (right MSB)
	*/
	
	case (stage)		
		4'b0000	:	ALU_ctrl = 3'b000; // PC+2
		4'b0001	:	ALU_ctrl = 3'b000; // JMP address
		
		4'b0010	:	begin
						case(IR[15:12]) //opcode = IR[15:12]
							4'b1000	:	ALU_ctrl = 3'b000;	//ADD reg
							4'b1100	:	ALU_ctrl = 3'b001;	//SUB reg
							4'b1011	:	ALU_ctrl = 3'b010;	//NAND reg
							4'b1111	:	ALU_ctrl = 3'b011;	//OR reg
							default	:	ALU_ctrl = 3'bxxx;
						endcase
					end
					
		4'b0011	: 	begin 	//shift
						case(IR[3:0])	//func_field = IR[3:0]
							4'b0001:  	ALU_ctrl = 3'b100; // shift left
							4'b0010:  	ALU_ctrl = 3'b101; // shift right logical
							4'b0011:  	ALU_ctrl = 3'b110; // shift right copy MSB
							default:	begin
											ALU_ctrl = 3'bxxx;
											error_log_2 = 1'b1;
										end
						endcase	
					end
					
		4'b0100	: 	begin
						case(IR[15:12])
							4'b1010	:	ALU_ctrl = 3'b000;	//ADD Imm zero
							4'b1110	:	ALU_ctrl = 3'b001;	//SUB Imm zero
							default	:	ALU_ctrl = 3'bxxx;
						endcase
					end
					
		4'b0101	: 	begin
						case(IR[15:12])
							4'b1001	:	ALU_ctrl = 3'b000;	//ADD imm MSB
							4'b1101	:	ALU_ctrl = 3'b001;	//SUB imm MSB
							4'b0111	:	ALU_ctrl = 3'b010;	//NAND imm MSB
							4'b0110	:	ALU_ctrl = 3'b011;	//OR imm MSB
							default	:	ALU_ctrl = 3'bxxx;
						endcase
					end
					
		4'b0110	: 	ALU_ctrl = 3'b000; // PC update for JMP
		4'b0111	: 	ALU_ctrl = 3'b000; // LOAD / STORE		
 		4'b1000	: 	ALU_ctrl = 3'b001; // BE / BNE
		
		4'b1001	: 	begin
						case(IR[15:12]) //opcode = IR[15:12]
							4'b1000	:	ALU_ctrl = 3'b000;	//ADD reg
							4'b1100	:	ALU_ctrl = 3'b001;	//SUB reg
							4'b1011	:	ALU_ctrl = 3'b010;	//NAND reg
							4'b1111	:	ALU_ctrl = 3'b011;	//OR reg
							4'b0000	:	begin 	//shift
											case(IR[3:0])	//func_field = IR[3:0]
												4'b0001:  ALU_ctrl = 3'b100; // shift left
												4'b0010:  ALU_ctrl = 3'b101; // shift right logical
												4'b0011:  ALU_ctrl = 3'b110; // shift right copy MSB
												default: ALU_ctrl = 3'bxxx;
											endcase
										end
							4'b1010	:	ALU_ctrl = 3'b000;	//ADD Imm zero
							4'b1110	:	ALU_ctrl = 3'b001;	//SUB Imm zero
							4'b1001	:	ALU_ctrl = 3'b000;	//ADD imm MSB
							4'b1101	:	ALU_ctrl = 3'b001;	//SUB imm MSB
							4'b0111	:	ALU_ctrl = 3'b010;	//NAND imm MSB
							4'b0110	:	ALU_ctrl = 3'b011;	//OR imm MSB
							default	:	ALU_ctrl = 3'bxxx;
						endcase
					end
					
		4'b1010	: 	ALU_ctrl = 3'b000; // LOAD
		4'b1011	: 	ALU_ctrl = 3'b000; // STORE
		4'b1100	: 	ALU_ctrl = 3'b000; // Maintain LOAD
 		default	: 	ALU_ctrl = 3'bxxx;
	endcase
end

//ALU_out
always@(posedge clk)
begin
	ALU_out = ALU_result;
end

//mux3
always@(*)
begin
	if (IR[12])
		mux3 = ~(zero);
	else
		mux3 = zero;
end
	
//Mux4
always@(*)
begin
	case(PC_src)
		2'b00	:	mux4 = ALU_result;
		2'b01	:	mux4 = ALU_out;
		2'b10	:	mux4 = C;
		default	:	mux4 = 16'bx;
	endcase
end	
	
//Data Memory
always@(posedge clk)
begin
	if (mem_read)
	begin
		read_addr = ALU_out;
		MDR[7:0] = data_mem[read_addr];
		MDR[15:8] = data_mem[read_addr + 16'd1];
	end
	
	else if (mem_write)
	begin
		write_addr = ALU_out;
		write_data = B;
		data_mem[write_addr] = write_data[7:0];
		data_mem[write_addr + 16'd1] = write_data[15:8];
		$writememh("data_mem.dat",data_mem);
	end
end

//mux5
always@(*)
begin
	case(mem_to_reg)
		1'b0	:	mux5 = ALU_out;
		1'b1	:	mux5 = MDR;
	endcase
end

//Main Control Unit
always@(*)
begin
	case(stage)
		4'b0000	:	begin						
						PC_write = 1'b1;
						IR_write = 1'b1;
						ALU_src_A = 3'd0;
						ALU_src_B = 3'd0;
						PC_src = 2'd0;
						reg_write = 1'b0;
						PC_write_cond = 1'b0;
						mem_to_reg = 1'b0;
						mem_read = 1'b0;
						mem_write = 1'b0;
					end

		4'b0001	:	begin
						PC_write = 1'b0;
						IR_write = 1'b0;
						ALU_src_A = 3'd0;
						ALU_src_B = 3'd4;							
					end

		4'b0010	:	begin
						ALU_src_A = 3'd1;
						ALU_src_B = 3'd1;
					end

		4'b0011	:	begin						
						ALU_src_A = 3'd4;
						ALU_src_B = 3'd2;
					end

		4'b0100	:	begin						
						ALU_src_A = 3'd3;
						ALU_src_B = 3'd2;
					end

		4'b0101	:	begin						
						ALU_src_A = 3'd2;
						ALU_src_B = 3'd2;
					end

		4'b0110	:	begin						
						PC_src = 1'd1;
						PC_write = 1'd1;
					end

		4'b0111	:	begin						
						ALU_src_A = 3'd1;
						ALU_src_B = 3'd3;
					end

		4'b1000	:	begin	
						ALU_src_A = 3'd1;
						ALU_src_B = 3'd1;
						PC_src = 2'd2;
						PC_write_cond = 1'b1;
					end

		4'b1001	:	begin						
						reg_write = 1'b1;
					end

		4'b1010	:	begin						
						mem_read = 1'b1;
					end

		4'b1011	:	begin						
						mem_write = 1'b1;
					end					

		4'b1100	:	begin						
						reg_write = 1'b1;
						mem_to_reg = 1'b1;
						mem_read = 1'b0;
					end
		
		default	:	begin						
						IR_write = 1'bx;
						reg_write = 1'bx;
						ALU_src_A = 3'bx;
						ALU_src_B = 3'bx;
						PC_src = 2'bx;
						PC_write = 1'bx;
						PC_write_cond = 1'bx;
						mem_to_reg = 1'bx;
						mem_read = 1'bx;
						mem_write = 1'bx;
					end
	endcase
end

//Main FSM
always@(posedge clk)
begin
	case(stage)
		4'b0000	:	stage = 4'b0001;
		
		4'b0001	:	begin
						case(IR[15:12])
							4'b0000	:	stage = 4'b0011;
							4'b0001	:	stage = 4'b0111;
							4'b0010	:	stage = 4'b0111;
							4'b0011	:	stage = 4'b0110;
							4'b0100	:	stage = 4'b1000;
							4'b0101	:	stage = 4'b1000;
							4'b0110	:	stage = 4'b0101;
							4'b0111	:	stage = 4'b0101;
							4'b1000	:	stage = 4'b0010;
							4'b1001	:	stage = 4'b0101;
							4'b1010	:	stage = 4'b0100;
							4'b1011	:	stage = 4'b0010;
							4'b1100	:	stage = 4'b0010;
							4'b1101	:	stage = 4'b0101;
							4'b1110	:	stage = 4'b0100;
							4'b1111	:	stage = 4'b0010;
							default	:	stage = 4'bxxxx;
						endcase
					end
					
		4'b0010	:	stage = 4'b1001;					
		4'b0011	:	stage = 4'b1001;
		4'b0100	:	stage = 4'b1001;
		4'b0101	:	stage = 4'b1001;
		4'b0110	:	stage = 4'b0000;
		
		4'b0111	:	begin
						case(IR[15:12])
							4'b0001	:	stage = 4'b1010;
							4'b0010	:	stage = 4'b1011;
							default	:	stage = 4'bxxxx;
						endcase
					end
					
		4'b1000	:	stage = 4'b0000;
		4'b1001	:	stage = 4'b0000;
		4'b1010	:	stage = 4'b1100;
		4'b1011	:	stage = 4'b0000;
		4'b1100	:	stage = 4'b0000;
		default	:	stage = 4'bxxxx;
	endcase
end

endmodule

//************************************************************************************************************************************************************************


