module full_adder (sum, cout, a, b, cin);
input a, b, cin;
output sum, cout;

assign sum = (a ^ b ^ cin);
assign cout = (a&b | b&cin | cin&a);

endmodule
 
 
// Testbench
module tb_full_adder ();
reg a, b, cin;
wire sum, cout;

integer i,j,k;
full_adder uut (.sum(sum), .cout(cout), .a(a), .b(b), .cin(cin));

initial begin
$monitor("a = %d	b = %d	cin = %d	sum = %d	cout = %d ", a, b, cin, sum, cout);

for(i=0; i<2; i=i+1) begin
	a <= i;
	for(j=0; j<2; j=j+1) begin
		b <= j;
		for(k=0; k<2; k=k+1) begin
			cin <= k;
			#(10);
		end
	end
end

end
endmodule
	