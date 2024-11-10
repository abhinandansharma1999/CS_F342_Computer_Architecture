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
module tb_bin_to_gray ();
wire [7:0] out_gray;
reg [7:0] in_binary;

bin_to_gray uut (out_gray, in_binary);

initial begin;
$monitor ("%b	%h", in_binary, out_gray);
#5 in_binary = 8'b11001110;
#5 in_binary = 8'b01101000;
#5 in_binary = 8'b00011001;
#5 in_binary = 8'b00011001;
#5 in_binary = 8'b10000001;
#5 in_binary = 8'b10100001;
#5 in_binary = 8'b10100011;
#5 in_binary = 8'b00001011;
#5 in_binary = 8'b00101011;
#5 in_binary = 8'b11100000;
#5 in_binary = 8'b10001110;
#5 in_binary = 8'b10110001;
#5 in_binary = 8'b01101101;
#5 in_binary = 8'b01100101;
#5 in_binary = 8'b11000010;
#5 in_binary = 8'b11110010;
#5 in_binary = 8'b10010000;
#5 in_binary = 8'b01000100;
#5 in_binary = 8'b00011000;
#5 in_binary = 8'b10011101;
#5 in_binary = 8'b11110010;
#5 in_binary = 8'b01101011;
#5 in_binary = 8'b10011101;
#5 in_binary = 8'b11011101;
#5 in_binary = 8'b00011101;
#5 in_binary = 8'b00011010;
#5 in_binary = 8'b00010000;
#5 in_binary = 8'b11100110;
#5 in_binary = 8'b00011000;
#5 in_binary = 8'b00000011;
#5 in_binary = 8'b11011011;
#5 in_binary = 8'b11001111;
#5 in_binary = 8'b00111010;
#5 in_binary = 8'b00111000;
#5 in_binary = 8'b01000011;
#5 in_binary = 8'b01010011;
#5 in_binary = 8'b00000101;
#5 in_binary = 8'b10100101;
#5 in_binary = 8'b10001001;
#5 in_binary = 8'b11010010;
#5 in_binary = 8'b01110000;
#5 in_binary = 8'b00010010;
#5 in_binary = 8'b10110100;
#5 in_binary = 8'b10110101;
#5 in_binary = 8'b01011110;
#5 in_binary = 8'b01001001;
#5 in_binary = 8'b11010010;
#5 in_binary = 8'b01110011;
#5 in_binary = 8'b11101001;
#5 in_binary = 8'b01111010;
#5 in_binary = 8'b11010001;
#5 in_binary = 8'b00011000;
#5 in_binary = 8'b01000001;
#5 in_binary = 8'b01000000;
#5 in_binary = 8'b00011011;
#5 in_binary = 8'b00011101;
#5 in_binary = 8'b10000000;
#5 in_binary = 8'b10101011;
#5 in_binary = 8'b01110111;
#5 in_binary = 8'b00100010;
#5 in_binary = 8'b10001000;
#5 in_binary = 8'b10100000;
#5 in_binary = 8'b01011000;
#5 in_binary = 8'b11011111;

end
endmodule
