module Frequency_Control(
						input				CLK,		//����ʱ��
						input				RST_n,		//ϵͳ��λ�����ź�	
						
						input				Fb,			//��׼Դ��50M Hz��
						input				Fx,			//�����ź�Ƶ��	
						//��Fx�����ؼ�⣬ʵ����Fx������ͬ�����Ӷ���֤������2�Ա����źŸպ�Ϊ����������,0���
						
							
						output		[29:0]	CLK_Data	//LCD 1602 ��������
						);								//999999999=27'h5f5e0ff
//reg			EN;			//�������ſ����źţ�ͨ��D��������ʱ�Ӵﵽͬ
reg			Finish;		//The Measure of the frequency is finished 
reg	[31:0]	cnt_Fb;		//��׼Դ	Fb 	������
reg	[31:0]	cnt_Fx;		//�����ź�	Fx	������

assign	CLK_Data = Finish ? (27'd50_000000/cnt_Fb * cnt_Fx) : 0;
//Frequency	=	(cnt_Fx * CLK) / cnt_Fb

//�Ⱦ���Ƶ�ʼ��ſ����ź�
//Gate�Ŀ��Tc�ͷ�����ʱ�䶼����ֱ��Ӱ�����ʹ���ź�EN��EN�����ڱ����ź�fx�����ظı䣬
//�Ӷ���֤�˱����źű�������������������������nTx�����뱻���źŵ�Ƶ���޹�
//always@(posedge Fx or negedge RST_n)		//D������ʵ�ֶԱ����ź�fx�����ؼ�⣬ʵ���ſ��ź���fx������ͬ����
//begin									//�Ӷ���֤������2�Ա����źż����պ�Ϊ���������ڣ�����
//	if(!RST_n)
//		EN <= 0;
//	else								//�ڱ����ź�fb�����ص���t2ʱ��D������Q�˲ű���1��
//		EN <= Gate;						//ʹ������1�ͼ�����2��ENͬʱΪ1����������ʼ������ϵͳ��������������ڡ�
//end

//Fb ��׼Դ����ģ��
always@(posedge Fb or negedge RST_n)		
begin
	if(!RST_n)
		cnt_Fb <= 0;
	else
		begin
		if(flag_1s==1'b1)//if(EN==1'b1)
			cnt_Fb <= cnt_Fb+1'b1;
		else
			cnt_Fb <= cnt_Fb;	//Locked		
		end
end

//FX �����źż���ģ��
always@(posedge Fx or negedge RST_n)		
begin
	if(!RST_n)
		cnt_Fx <= 0;
	else
		begin
		if(flag_1s==1'b1)//if(EN==1'b1)
			cnt_Fx <= cnt_Fx+1'b1;
		else
			cnt_Fx <= cnt_Fx;	//Locked		
		end
end

reg	[26:0]	cnt_1s;		
reg			flag_1s;
always@(posedge CLK or negedge RST_n)
begin
	if(!RST_n)
		begin
		cnt_1s <= 0;
		flag_1s <= 0;
		Finish <= 0;
		end
	else
		begin
		if(cnt_1s < 27'd50_000000)	//1s
			begin
			cnt_1s <= cnt_1s+1'b1;
			flag_1s <= 1;
			Finish	<= 0;
			end
		else
			begin
			cnt_1s <= cnt_1s;
			flag_1s <= 0;		//The signal means that it has reach the time of 1S
			Finish <= 1;		//Lock the signal Finish for math calculation
			end
		end
end



endmodule
