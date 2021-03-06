module main(
	Clock,
	SW2,
	SW1,
	SW0,
	F_in,
	dp,
	disp_data,
	disp_select,
	over_alarm
);

input	Clock;
input	SW2;
input	SW1;
input	SW0;
input	F_in;

output  over_alarm; 
output	dp;
output	[6:0] disp_data;
output	[5:0] disp_select;

wire	EN;
wire	CLR;
wire	Latch_EN;

wire	f1hz;
wire	f10hz;
wire	f100hz;
wire	f1khz;
wire	dp_s1hz;
wire	dp_s10hz;
wire	dp_s100hz;
wire	F_out;
wire	[3:0] Q;
wire	[2:0] select;

wire	[3:0] A0;
wire	[3:0] A1;
wire	[3:0] A2;
wire	[3:0] A3;
wire	[3:0] A4;
wire	[3:0] A5;

wire	[3:0] Q0;
wire	[3:0] Q1;
wire	[3:0] Q2;
wire	[3:0] Q3;
wire	[3:0] Q4;
wire	[3:0] Q5;
assign	over_alarm = F_out;




counter	b2v_inst
(.EN(EN),
.CLR(CLR),
.F_IN(F_IN),
.F_OUT(F_out),
.Q0(A0),.Q1(A1),.Q2(A2),.Q3(A3),.Q4(A4),.Q5(A5)
);

fdiv	b2v_inst1
(.clk(Clock),
.f1hz(f1hz),
.f10hz(f10hz),
.f100hz(f100hz),
.f1khz(f1khz)
);

flip_latch	b2v_inst2
(.clk(Latch_EN),
.A0(A0),.A1(A1),.A2(A2),.A3(A3),.A4(A4),.A5(A5),
.Q0(Q0),.Q1(Q1),.Q2(Q2),.Q3(Q3),.Q4(Q4),.Q5(Q5)
);

gate_control	b2v_inst3
(.SW0(SW0),.SW1(SW1),.SW2(SW2),
.f1hz(f1hz),
.f10hz(f10hz),
.f100hz(f100hz),
.Latch_EN(Latch_EN),
.Counter_Clr(CLR),
.Counter_EN(EN),
.dp_s1hz(dp_s1hz),.dp_s10hz(dp_s10hz),.dp_s100hz(dp_s100hz)
);

dispdecoder	b2v_inst5
(.dp_s1hz(dp_s1hz),.dp_s10hz(dp_s10hz),.dp_s100hz(dp_s100hz),
.counter_out(F_out),
.data_in(Q),.disp_select(disp_select),
.Q0(A0),.Q1(A1),.Q2(A2),.Q3(A3),.Q4(A4),.Q5(A5),
.dp(dp),
.data_out(disp_data)
);

dispselect	b2v_inst7
(.clk(f1khz),
.disp_select(select),
.Q(disp_select)
);

data_mux	b2v_inst8(
.A0(Q0),.A1(Q1),.A2(Q2),.A3(Q3),.A4(Q4),.A5(Q5),
.disp_select(select),
.Q(Q)
);


endmodule
