module mux_4to1 (out, a0, a1, a2, a3, s0, s1);
input a0, a1, a2, a3, s0, s1;
output out;

assign out = s0 ? (s1 ? a3 : a2) : (s1 ? a1 : a0);

endmodule


//Testbench
module tb_mux_4to1 ();
reg a0, a1, a2, a3, s0, s1;
wire out;

integer i, j, k, l, m, n;
mux_4to1 uut (.out(out), .a0(a0), .a1(a1), .a2(a2), .a3(a3), .s0(s0), .s1(s1));

initial begin
$monitor("a0 = %d	a1 = %d	a2 = %d	a3 = %d		s0 = %d	s1 = %d		out = %d ", a0, a1, a2, a3, s0, s1, out);

for(i=0; i<2; i=i+1) begin
	a0 <= i;
	for(j=0; j<2; j=j+1) begin
		a1 <= j;
		for(k=0; k<2; k=k+1) begin
			a2 <= k;
			for(l=0; l<2; l=l+1) begin
				a3 <= l;
				for(m=0; m<2; m=m+1) begin
					s0 <= m;
					for(n=0; n<2; n=n+1) begin
						s1 <= n;
						#(1);
					end
				end
			end
		end
	end
end

end
endmodule