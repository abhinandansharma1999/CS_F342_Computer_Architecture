module johnson_counter_4bit (Q_a, Q_b, Q_c, Q_d, rst, clk);
input clk, rst;
output Q_a, Q_b, Q_c, Q_d;

wire Q_bar_a, Q_bar_b, Q_bar_c, Q_bar_d;

JK_FF JK1 (.Q(Q_a), .Q_bar(Q_bar_a), .J(Q_bar_d), .K(Q_d), .rst(rst), .clk(clk));
JK_FF JK2 (.Q(Q_b), .Q_bar(Q_bar_b), .J(Q_a), .K(Q_bar_a), .rst(rst), .clk(clk));
JK_FF JK3 (.Q(Q_c), .Q_bar(Q_bar_c), .J(Q_b), .K(Q_bar_b), .rst(rst), .clk(clk));
JK_FF JK4 (.Q(Q_d), .Q_bar(Q_bar_d), .J(Q_c), .K(Q_bar_c), .rst(rst), .clk(clk));

endmodule

module JK_FF (Q, Q_bar, J, K, rst, clk);
input J, K, clk, rst;
output Q, Q_bar;

reg Q = 1'b0;
reg Q_bar = 1'b1;

always@(posedge clk)
begin

if (rst)
begin
	Q <= 1'b0;
	Q_bar <= 1'b1;
end

else
begin
	case ({J, K})
		2'b00 	: begin Q <= Q; 	Q_bar <= Q_bar;  end
		2'b01 	: begin Q <= 1'b0; 	Q_bar <= 1'b1; 	 end
		2'b10 	: begin Q <= 1'b1; 	Q_bar <= 1'b0; 	 end
		2'b11 	: begin Q <= ~Q; 	Q_bar <= ~Q_bar; end
		default : begin Q <= 1'b1; 	Q_bar <= 1'b0;	 end
	endcase
end

end
endmodule


// Testbench
module tb_johnson_counter_4bit();
reg clk, rst;
wire Q_a, Q_b, Q_c, Q_d;

parameter T =20;

johnson_counter_4bit uut (.Q_a(Q_a), .Q_b(Q_b), .Q_c(Q_c), .Q_d(Q_d), .rst(rst), .clk(clk));

initial
begin
clk = 1'b0;
forever #(T/2) clk = ~clk;
end

initial
begin
$monitor("Q_a=%d	Q_b=%d	Q_c=%d	Q_d=%d", Q_a, Q_b, Q_c, Q_d);
rst = 1'b0;
#(35*T) rst = 1'b1;
#(2*T) rst = 1'b0;
#(15*T) $stop;
end

endmodule