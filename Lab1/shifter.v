module shifter (Y, A, Opcode);
input [7:0] A;
input [2:0] Opcode;
output [7:0] Y;

wire [7:0] Y0 = {A[6:0], 1'b0};
wire [7:0] Y1 = {1'b0, A[7:1]};
wire [7:0] Y2 = {A[7], A[7:1]};
wire [7:0] Y3 = {A[6:0], A[7]};
wire [7:0] Y4 = {A[0], A[7:1]};

assign Y = (Opcode == 3'b001) ? Y0 : ((Opcode == 3'b100) ? Y1 : ((Opcode == 3'b101) ? Y2 : ((Opcode == 3'b010) ? Y3 : ((Opcode == 3'b110) ? Y4 : A))));
// In the default case, A is passed as it is without any operation.
endmodule


//Testbench
module tb_shifter();
reg [7:0] A;
reg [2:0] Opcode;
wire [7:0] Y;

shifter uut (.Y(Y), .A(A), .Opcode(Opcode));

initial begin
$monitor("A = %b	Opcode = %b	Y = %b", A, Opcode, Y);

A = 8'b10001100;
Opcode = 3'b001;
#1
Opcode = 3'b100;
#1
Opcode = 3'b101;
#1
Opcode = 3'b010;
#1
Opcode = 3'b110;
#1
Opcode = 3'b000;

end
endmodule


