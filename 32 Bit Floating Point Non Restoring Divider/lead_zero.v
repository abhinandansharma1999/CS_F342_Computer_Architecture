module lead_zero(a,b);
input wire [23:0] a;
output reg [4:0]b;

always @(*)
begin

casez(a)
24'b1???????????????????????: b = 5'd0;
24'b01??????????????????????: b = 5'd1;
24'b001?????????????????????: b = 5'd2;
24'b0001????????????????????: b = 5'd3;
24'b00001???????????????????: b = 5'd4;
24'b000001??????????????????: b = 5'd5;
24'b0000001?????????????????: b = 5'd6;
24'b00000001????????????????: b = 5'd7;
24'b000000001???????????????: b = 5'd8;
24'b0000000001??????????????: b = 5'd9;
24'b00000000001?????????????: b = 5'd10;
24'b000000000001????????????: b = 5'd11;
24'b0000000000001???????????: b = 5'd12;
24'b00000000000001??????????: b = 5'd13;
24'b000000000000001?????????: b = 5'd14;
24'b0000000000000001????????: b = 5'd15;
24'b00000000000000001???????: b = 5'd16;
24'b000000000000000001??????: b = 5'd17;
24'b0000000000000000001?????: b = 5'd18;
24'b00000000000000000001????: b = 5'd19;
24'b000000000000000000001???: b = 5'd20;
24'b0000000000000000000001??: b = 5'd21;
24'b00000000000000000000001?: b = 5'd22;
24'b000000000000000000000001: b = 5'd23;
24'b000000000000000000000000: b = 5'd24;
endcase

end

endmodule