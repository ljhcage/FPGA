module gate_control(
					SW0,SW1,SW2,
					f1hz,f10hz,f100hz,
					Latch_EN,
					Counter_Clr,
					Counter_EN,
					dp_s1hz,dp_s10hz,dp_s100hz
					); 
output Latch_EN;
output Counter_Clr;
output Counter_EN;
output dp_s1hz,dp_s10hz,dp_s100hz;

input  SW0,SW1,SW2;
input  f1hz,f10hz,f100hz;

reg dp_s1hz,dp_s10hz,dp_s100hz;

reg fref;
reg wire_1;
reg wire_2;

//��ʼ�������Լ��м���
initial
begin
  fref <= 1'b0;

  wire_1  <= 1'b0;
  wire_2  <= 1'b0;
end


//���ݲ�ͬ���������ѡ��ѡ����Ӧ�ļ�����ʱ��
always @(SW0 or SW1 or SW2 or f1hz or f10hz or f100hz)
begin
  if(SW2 == 1'b0)                                            //key
    begin
      fref <= f100hz;
      {dp_s1hz,dp_s10hz,dp_s100hz} <= 3'b001;
    end
  else if(SW1 == 1'b0)
    begin
      fref <= f10hz;
      {dp_s1hz,dp_s10hz,dp_s100hz} <= 3'b010;
    end
  else if(SW0 == 1'b0)
    begin
      fref <= f1hz;
      {dp_s1hz,dp_s10hz,dp_s100hz} <= 3'b100;
    end
end


//���ݲ�ͬ�ļ�����ʱ�ӣ��ṩ�����Ӧ�ļ���������ֵ�������������������������
always @(posedge fref)
begin
  wire_1 <= ! wire_1;
end

always @(negedge fref)
begin
    wire_2 <= wire_1;
end

assign Counter_EN  = wire_1;
assign Latch_EN    = (! Counter_EN) & wire_2;
assign Counter_Clr = (! Counter_EN) & (! Latch_EN) & (! wire_2);

endmodule 