module mo60(
    input ce,//暂停
    input cp,//时钟
    input cr,//清零
    output [3:0] cs, //位选型号
    output [7:0] seg //段选信号
    );

    wire cp0; //计数时钟定义
    fre2 U0(   
    .cp(cp),   
    .cp0(cp0)   
    ); 
    
	 wire cp1;  //扫描LED时钟定义
	 fre1000 U1(
	 .cp(cp),
	 .cp1(cp1)
	 );
	 
	 wire tc;    //进位信号
    wire [3:0]q10;   
    cnt10 U2(   
	 .cp0(cp0),   
	 .ce(ce),   
	 .cr(cr),   
	 .tc(tc),   
	 .q10(q10[3:0])   
	 );      

    wire [3:0]q6;   
	 cnt6 U3(   
	 .tc(tc),   
	 .cr(cr),   
	 .q6(q6[3:0])   
	 );      

    slt U4(   
	 .cp1(cp1),   
	 .cs(cs[3:0])   
	 );      
    
	 wire [3:0]q;
    selector U5(   
	 .q0(q6[3:0]),     
	 .q1(q10[3:0]),   
	 .cs(cs[3:0]),   
	 .q(q[3:0])   
	 );      

    decoder U6(   
	 .q(q[3:0]),   
	 .seg(seg[7:0])   
	 );    
endmodule 

module fre2(   
     input cp,   
     output reg cp0    
      );   
     reg [24:0]cnt=0;   
     always@(posedge cp)   
     begin    
         cnt<=cnt+1'b1;     
         if(cnt>=25'b1011111010111100000111111)//25000000-1,把50MHz分 频为2Hz     
     begin     
         cp0<=~cp0;     
         cnt<={25{1'b0}};    
	  end   
end     
endmodule   


module fre1000(   
input cp,   
output reg cp1    
 );   
reg [15:0]cnt=0;   
always@(posedge cp)   
begin    
cnt<=cnt+1'b1;    
if(cnt>=16'b1100001101001111)//50000-1,把50MHz分频为1000Hz    
begin     
cp1<=~cp1;        
cnt<={16{1'b0}};    
end   
end    
endmodule   


module cnt10(   
input cp0,   
input ce,  
input cr,   
output reg tc,   
output reg [3:0]q10   
);         //10进制计数器
always@(posedge cp0 or negedge cr)   //检测到cp0计数时钟或检测到清零信号时进入循环，否则不变
begin   
tc<=1'b0;   
if(~cr)     
q10<=4'b0000;   //检测到清零，清零
else if(~ce)    //检测到暂停，暂停
q10<=q10;   
else if(q10>=4'b1001)   //如果计数满9
begin    
q10<=4'b0000;        //清零
tc<=1'b1;   //进位加1
end   
else    
q10<=q10+1'b1;  //否则个位加1
end   
endmodule   



module cnt6(   
input tc,   
input cr,   
output reg [3:0]q6=0   
);      //6进制计数器
always@(posedge tc or negedge cr)   //当检测到进位加1时或者清零信号时循环，否则不变
begin   
if(~cr)     //检测到清零，清零
q6<=4'b0000;   
else if(q6>=4'b0101)    //当高位记满5时
q6<=4'b0000;      //清零
else    
q6<=q6+1'b1;   //否则高位加1
end   
endmodule  




module slt(  
input cp1,  
output [3:0]cs     
);           //LED位选信号，共阳极
assign cs[0]=cp1;  //第一位数码管定义为CP1
assign cs[1]=~cp1;  //第二位数码管为CP1取反
assign cs[2]=1'b1;  
assign cs[3]=1'b1;   //高两位数码管清零
endmodule   



module selector(  
input [3:0]q0,  
input [3:0]q1,  
input [3:0]cs,  
output [3:0]q     
);      
assign q=cs[0]?q1:q0;   //如果为CP1，则把10进制计数结果赋给数码管段选，否则把6进制计数结果赋给数码管段选，位选则由cp1决定
endmodule   


module decoder(  
input [3:0]q,  
output reg [7:0]seg     
);        //数码管段选二进制定义
always@(*)   begin       case(q)         
4'h1:seg = 8'b11111001;     
4'h2:seg = 8'b10100100;     
4'h3:seg = 8'b10110000;     
4'h4:seg = 8'b10011001;     
4'h5:seg = 8'b10010010;          
4'h6:seg = 8'b10000010;     
4'h7:seg = 8'b11111000;     
4'h8:seg = 8'b10000000;     
4'h9:seg = 8'b10010000;     
4'hA:seg = 8'b10001000;     
4'hB:seg = 8'b10000011;     
4'hC:seg = 8'b11000110;     
4'hD:seg = 8'b10100001;     
4'hE:seg = 8'b10000110;     
4'hF:seg = 8'b10001110;     
default:seg = 8'b11000000;    
endcase   
end     

endmodule
