module tb_fpdiv();
reg CLOCK;
reg RESET;
reg [31:0] InputA;
reg [31:0] InputB;

wire [31:0] AbyB;
wire DONE;
wire [1:0] EXCEPTION;
reg [31:0] ans;

fpdiv uut(.AbyB(AbyB), .DONE(DONE), .EXCEPTION(EXCEPTION), .InputA(InputA), .InputB(InputB), .CLOCK(CLOCK),
 .RESET(RESET));

initial
begin
CLOCK = 1'b0;
forever #250 CLOCK = ~CLOCK;
end
	
initial
begin

/* $monitor("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);
 */

RESET = 1'b0;	
/*
InputA = 32'b01111111100000000000000000000000;
InputB = 32'b01111111100000000000000000000000; //+inf/+inf
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000000000000;
InputB = 32'b01111111100000000000000000000000; //-inf/+inf
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000000000000;
InputB = 32'b11111111100000000000000000000000; //-inf/-inf
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b01111111100000000000000000000000;
InputB = 32'b11111111100000000000000000000000; //+inf/-inf
ans    = 32'b11111111111111111111111111111111; //NaN	
#250	
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b01111111100000000000000000000000;
InputB = 32'b00101001000010010000000000111111; //+inf/+n
ans    = 32'b01111111100000000000000000000000; //+inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000000000000;
InputB = 32'b00101001000010010000000000111111; //-inf/+n
ans    = 32'b11111111100000000000000000000000; //-inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b01111111100000000000000000000000;
InputB = 32'b10101001000010010000000000111111; //+inf/-n
ans    = 32'b11111111100000000000000000000000; //-inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000000000000;
InputB = 32'b10101001000010010000000000111111; //-inf/-n
ans    = 32'b01111111100000000000000000000000; //+inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00101001000010010000000000111111;
InputB = 32'b01111111100000000000000000000000; //+n/+inf
ans    = 32'b00000000000000000000000000000000; //+0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00101001000010010000000000111111;
InputB = 32'b11111111100000000000000000000000; //+n/-inf
ans    = 32'b10000000000000000000000000000000; //-0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10101001000010010000000000111111;
InputB = 32'b01111111100000000000000000000000; //-n/+inf
ans    = 32'b10000000000000000000000000000000; //-0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10101001000010010000000000111111;
InputB = 32'b11111111100000000000000000000000; //-n/-inf
ans    = 32'b00000000000000000000000000000000; //+0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b01111111100000000000000000000000;
InputB = 32'b00000000000000000000000000000000; //+inf/+0
ans    = 32'b01111111100000000000000000000000; //+inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000000000000;
InputB = 32'b00000000000000000000000000000000; //-inf/+0
ans    = 32'b11111111100000000000000000000000; //-inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000000000000;
InputB = 32'b10000000000000000000000000000000; //-inf/-0
ans    = 32'b01111111100000000000000000000000; //+inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b01111111100000000000000000000000;
InputB = 32'b10000000000000000000000000000000; //+inf/-0
ans    = 32'b11111111100000000000000000000000; //-inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000000;
InputB = 32'b01111111100000000000000000000000; //+0/+inf
ans    = 32'b00000000000000000000000000000000; //+0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10000000000000000000000000000000;
InputB = 32'b01111111100000000000000000000000; //-0/+inf
ans    = 32'b10000000000000000000000000000000; //-0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10000000000000000000000000000000;
InputB = 32'b11111111100000000000000000000000; //-0/-inf
ans    = 32'b00000000000000000000000000000000; //+0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000000;
InputB = 32'b11111111100000000000000000000000; //+0/-inf
ans    = 32'b10000000000000000000000000000000; //-0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000000;
InputB = 32'b00000000000000000000000000000000; //+0/+0
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10000000000000000000000000000000;
InputB = 32'b00000000000000000000000000000000; //-0/+0
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10000000000000000000000000000000;
InputB = 32'b10000000000000000000000000000000; //-0/-0
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000000;
InputB = 32'b10000000000000000000000000000000; //+0/-0
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000000;
InputB = 32'b00101001000010010000000000111111; //+0/+n
ans    = 32'b00000000000000000000000000000000; //+0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10000000000000000000000000000000;
InputB = 32'b00101001000010010000000000111111; //-0/+n
ans    = 32'b10000000000000000000000000000000; //-0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000000;
InputB = 32'b10101001000010010000000000111111; //+0/-n
ans    = 32'b10000000000000000000000000000000; //-0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10000000000000000000000000000000;
InputB = 32'b10101001000010010000000000111111; //-0/-n
ans    = 32'b00000000000000000000000000000000; //+0
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);
	
#250

InputA = 32'b00101001000010010000000000111111;
InputB = 32'b00000000000000000000000000000000; //+n/+0
ans    = 32'b01111111100000000000000000000000; //+inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00101001000010010000000000111111;
InputB = 32'b10000000000000000000000000000000; //+n/-0
ans    = 32'b11111111100000000000000000000000; //-inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10101001000010010000000000111111;
InputB = 32'b00000000000000000000000000000000; //-n/+0
ans    = 32'b11111111100000000000000000000000; //-inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b10101001000010010000000000111111;
InputB = 32'b10000000000000000000000000000000; //-n/-0
ans    = 32'b01111111100000000000000000000000; //+inf
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00101001000010010000000000111111;
InputB = 32'b01111111100000000000000010110100; //+n/+NaN
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000010110100;
InputB = 32'b00101001000010010000000000111111; //-NaN/+n
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000010110100;
InputB = 32'b00000000000000000000000000000000; //-NaN/+0
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000010110100;
InputB = 32'b10000000000000000000000000000000; //-NaN/-0
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b11111111100000000000000010110100;
InputB = 32'b11111111100000000000000000000000; //-NaN/-inf
ans    = 32'b11111111111111111111111111111111; //NaN
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b\n\n",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

// ************************************************************************************************

#250
*/
InputA = 32'b00010001011111111111111111111111;
InputB = 32'b00000000011111111111111111111111; //highest normal/highest subnormal
ans    = 32'b01010000100000000000000000000001;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001011111111111111111111111;
InputB = 32'b00000000000000000000000000000001; //highest normal/lowest subnormal
ans    = 32'b01011011111111111111111111111111;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001000000000000000000000001;
InputB = 32'b00000000000000000000000000000001; //lowest normal/lowest subnormal
ans    = 32'b01011011100000000000000000000001;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001000000000000000000000001;
InputB = 32'b00000000011111111111111111111111; //lowest normal/highest subnormal
ans    = 32'b01010000000000000000000000000010;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000011111111111111111111111;
InputB = 32'b00010001011111111111111111111111; //highest subnormal/highest normal
ans    = 32'b00101110011111111111111111111111;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000001;
InputB = 32'b00010001011111111111111111111111; //lowest subnormal/highest normal
ans    = 32'b00100011000000000000000000000001;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000001;
InputB = 32'b00010001000000000000000000000001; //lowest subnormal/lowest normal
ans    = 32'b00100011011111111111111111111110;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000011111111111111111111111;
InputB = 32'b00010001000000000000000000000001; //highest subnormal/lowest normal
ans    = 32'b00101110111111111111111111111100;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001011111111111111111111111;
InputB = 32'b00010001011111111111111111111111; //highest normal/highest normal
ans    = 32'b00111111100000000000000000000000; //1
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001011111111111111111111111;
InputB = 32'b00010001000000000000000000000001; //highest normal/lowest normal
ans    = 32'b00111111111111111111111111111101;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001000000000000000000000001;
InputB = 32'b00010001011111111111111111111111; //lowest normal/highest normal
ans    = 32'b00111111000000000000000000000010;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00010001000000000000000000000001;
InputB = 32'b00010001000000000000000000000001; //lowest normal/lowest normal
ans    = 32'b00111111100000000000000000000000; //1
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000011111111111111111111111;
InputB = 32'b00000000011111111111111111111111; //highest subnormal/highest subnormal
ans    = 32'b00111111100000000000000000000000; //1
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000011111111111111111111111;
InputB = 32'b00000000000000000000000000000001; //highest subnormal/lowest subnormal
ans    = 32'b01001010111111111111111111111110;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000001;
InputB = 32'b00000000011111111111111111111111; //lowest subnormal/highest subnormal
ans    = 32'b00110100000000000000000000000001;
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000000000000000000000000001;
InputB = 32'b00000000000000000000000000000001; //lowest subnormal/lowest subnormal
ans    = 32'b00111111100000000000000000000000; //1
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b\n\n",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

// ************************************************************************************************
#250

InputA = 32'b01000000010000000000000000000011;	//just less than overflow
InputB = 32'b00000000011111111000001111111111;
ans    = 32'b01111111010000001011101010111001; 
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b01000000110000000000000000000011;	//overflow (inf)
InputB = 32'b00000000011111111000001111111111;
ans    = 32'b01111111100000000000000000000000; 
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000010000000000010000000000; //just greater than subnormal
InputB = 32'b00111110101111110000000000000000;
ans    = 32'b00000000101010111001101000100011; 
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);
#250

InputA = 32'b00000000010000000000010000000000; //largest subnormal
InputB = 32'b00111111001111110000000000000000;
ans    = 32'b00000000010101011100110100010001; 
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000010000000000010000000000; //just greater than underflow (lowest subnormal)
InputB = 32'b01001010101111110000000000000000;
ans    = 32'b00000000000000000000000000000001; 
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);

#250

InputA = 32'b00000000010000000000010000000000; //underflow (zero)
InputB = 32'b01001011001111110000000000000000;
ans    = 32'b00000000000000000000000000000000;  
#250
$strobe("InputA = %b_%b_%b	InputB = %b_%b_%b	AbyB = %b_%b_%b	EXCEPTION = %b	ans = %b_%b_%b	done = %b",
InputA[31],InputA[30:23],InputA[22:0], InputB[31],InputB[30:23],InputB[22:0], AbyB[31], AbyB[30:23], AbyB[22:0],
EXCEPTION, ans[31],ans[30:23],ans[22:0], DONE);
	
#10
$stop;
end
endmodule
	
	