module freq(
						input			CLK,		//50M 
						input			RST_n,		//ϵͳ��λ
						
						input			Fx,			//CLK	�����ź�Ƶ��	
						//��Fx�����ؼ�⣬ʵ����Fx������ͬ�����Ӷ���֤������2�Ա����źŸպ�Ϊ����������,0���
						output			LCD_EN,
						output			LCD_RS,
						output			LCD_RW,
						output	[7:0]	LCD_Data
						);
						
wire	[29:0]	CLK_Data;
wire	[71:0]	Frequency;
						
Frequency_Control FreQ	(
						.CLK		(CLK),
						.RST_n		(RST_n),
						.Fb			(CLK),
						.Fx			(Fx),
						.CLK_Data	(CLK_Data)	//[29:0]
						);
						
//LCD_Data IO Define
LCD_1602 U_LCD(//input
			.CLK		(CLK),
			.RST_n		(RST_n),
			.CLK_Data	(Frequency),			//[71:0]
			.LCD_EN		(LCD_EN),
			.LCD_RS		(LCD_RS),
			.LCD_RW		(LCD_RW),
			.LCD_Data	(LCD_Data)
			);

//Frequency Data Convert
Data_Convert UData(
					.CLK(CLK),
					.Data_in(CLK_Data),
					.Data_out(Frequency)
					);

endmodule
