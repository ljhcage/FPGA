/***************************************************************************************
FILE NAME      :     Frequency_Counter
AUTHOR         :     Crazy Bingo
FUNCTION       :     MCU430 and CPLD to control the Frequency counter 
FEATURE        :     EPM240T100C5N
SETUP TIME     :     2010/5/6
***************************************************************************************/
module Frequency_Counter(
						input				CLOCK_50,		//板载时钟
						input				RST_n,		//系统复位清零信号	
						
						input				Fx,			//被测信号频率	
						//对Fx上升沿检测，实现与Fx上升沿同步，从而保证计数器2对被测信号刚好为整数个周期,0误差
						input				Cnt_Sel,	//频率计数选择（cnt_Fb,cnt_Fx）
						input		[1:0]	Byte_Sel,	//CLK计数器地址位选				
						
						output	reg			Finish,		//The Measure of the frequency is finished 		
						output	reg	[7:0]	Freq_Data	//发送频率计
						);	
													//999_999999=27'h3b9ac9ff
reg			cnt_EN;		//计数器门控制信号，通过D触发器与时钟达到同
reg			Finish_r;
reg	[31:0]	cnt_Fb;		//基准源	Fb 	计数器	//32'hFFFFFFFF=32'd4294967295=429 MHz
reg	[31:0]	cnt_Fx;		//被测信号	Fx	计数器
reg	[26:0]	cnt_1s;		
reg			cnt_Flag;
reg	[15:0]	cnt;


always@(posedge CLOCK_50 or negedge RST_n)
begin
	if(!RST_n)
		begin
		cnt_1s <= 0;
		cnt_Flag <= 0;
		Finish_r <= 0;
		end
	else
		begin
		if(cnt_1s < 27'd50_000000)	//2s
			begin
			cnt_1s <= cnt_1s+1'b1;
			cnt_Flag <= 1;
			Finish_r <= 0;
			end
		else
			begin
			cnt_1s <= cnt_1s;
			cnt_Flag <= 0;		//The signal means that it has reach the time of 1S
			Finish_r <= 1;		//Lock the signal Finish for math calculation
			end
		end
end

//等精度频率计门控制信号
//Gate的宽度Tc和发生的时间都不会直接影响计数使能信号EN，EN总是在被测信号fx上升沿改变，
//从而保证了被测信号被计数的周期总是整数个周期nTx，而与被测信号的频率无关
always@(posedge Fx or negedge RST_n)	//D触发器实现对被测信号fx上升沿检测，实现门控信号与fx上升沿同步，
begin									//从而保证计数器2对被测信号计数刚好为整数个周期，零误差。
	if(!RST_n)
		begin
		cnt_EN <= 0;
		Finish <= 0;
		end
	else								//在被测信号fb上升沿到来t2时刻D触发器Q端才被置1
		begin
		if(cnt_Flag==1'b1)
			cnt_EN <= 1;				//使计数器1和计数器2的EN同时为1，计数器开始计数，系统进入计数允许周期。
		else
			cnt_EN <= 0;
		
		if(Finish_r==1'b1)
			Finish <= 1;
		else
			Finish <= 0;
		end
end

////Fb 基准源计数模块
always@(posedge CLOCK_50 or negedge RST_n)		
begin
	if(!RST_n)
		cnt_Fb <= 0;
	else
		begin
		if(cnt_Flag==1'b1)//if(EN==1'b1)
			cnt_Fb <= cnt_Fb+1'b1;
		else
			cnt_Fb <= cnt_Fb;	//Locked		
		end
end
//
////FX 被测信号计数模块
always@(posedge Fx  or negedge RST_n)		
begin
	if(!RST_n)
		cnt_Fx <= 0;
	else
		begin
		if(cnt_Flag==1'b1)//if(EN==1'b1)
			cnt_Fx <= cnt_Fx+1'b1;
		else
			cnt_Fx <= cnt_Fx;	//Locked		
		end
end

//cnt_Fb,cnt_Fb		32位计数器，分成2个16位送出
//Freq_Data[15:0]	16位数据总线
//MCU  				接收数据并做相应处理
//always@(RD,Cnt_Sel,Byte_Sel,cnt_Fb,cnt_Fx)

//always@(posedge CLOCK_50 or negedge RST_n)
always@(Cnt_Sel,Byte_Sel,cnt_Fb,cnt_Fx)
begin
//	cnt_Fb=32'd50_000000;	//32'h02_FA_F0_80
	//cnt_Fx=32'd1000000;	   //32'h00_98_96_80
	case({Cnt_Sel,Byte_Sel})
	4'b000	:		Freq_Data <= cnt_Fb[7:0];	//Fb 基准源计数模块
	4'b001	:		Freq_Data <= cnt_Fb[15:8];
	4'b010	:		Freq_Data <= cnt_Fb[23:16];
	4'b011	:		Freq_Data <= cnt_Fb[31:24];	
	4'b100	:		Freq_Data <= cnt_Fx[7:0];	//Fx 被测信号计数模块
	4'b101	:		Freq_Data <= cnt_Fx[15:8];
	4'b110	:		Freq_Data <= cnt_Fx[23:16];
	4'b111	:		Freq_Data <= cnt_Fx[31:24];
	endcase 	
end

endmodule
