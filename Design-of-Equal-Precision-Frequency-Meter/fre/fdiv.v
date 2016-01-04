module fdiv(clk,f1hz,f10hz,f100hz,f1khz);

output f1hz,f10hz,f100hz,f1khz;
input  clk;

reg f1hz,f10hz,f100hz,f1khz;
integer cnt1=0,cnt2=0,cnt3=0,cnt4=0;

always @(posedge clk)
begin
	//if(cnt1<9999)   //ʵ��ϵͳ��Ƶֵ
	if(cnt1 < 2)  //����ʱ�ķ�Ƶֵ
	begin
	  f1khz <= 1'b0;
	  cnt1 = cnt1 + 1;
	end
	else
	begin
	  f1khz <= 1'b1;
	  cnt1 = 0;
	end
end

always @(posedge f1khz)
begin
	//if(cnt2<9)     //ʵ��ϵͳ��Ƶֵ
	if(cnt2 < 2)  //����ʱ�ķ�Ƶֵ
	begin
	  f100hz <= 1'b0;
	  cnt2 = cnt2 + 1;
	end
	else
	begin
	  f100hz <= 1'b1;
	  cnt2 = 0;
	end
end

always @(posedge f100hz)
begin
	//if(cnt3<9)     //ʵ��ϵͳ��Ƶֵ
	if(cnt3 < 2)  //����ʱ�ķ�Ƶֵ
	begin
	  f10hz <= 1'b0;
	  cnt3 = cnt3 + 1;
	end
	else
	begin
	  f10hz <= 1'b1;
	  cnt3 = 0;
	end
end

always @(posedge f10hz)
begin
	//if(cnt4<9)      //ʵ��ϵͳ��Ƶֵ
	if(cnt4 < 2)  //����ʱ�ķ�Ƶֵ
	begin
	  f1hz <= 1'b0;
	  cnt4 = cnt4 + 1;
	end
	else
	begin
	  f1hz <= 1'b1;
	  cnt4 = 0;
	end
end

endmodule 