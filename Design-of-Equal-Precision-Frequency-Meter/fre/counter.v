module counter(EN,CLR,F_IN,F_OUT,Q0,Q1,Q2,Q3,Q4,Q5);

output [3:0] Q5,Q4,Q3,Q2,Q1,Q0;
output F_OUT;
input  EN;
input  CLR;
input  F_IN;

reg [3:0] Q5,Q4,Q3,Q2,Q1,Q0;
reg F_OUT;

reg F_out0,F_out1,F_out2,F_out3,F_out4;

initial 
begin
  F_OUT <= 1'b1;
end

always @(posedge F_IN)
begin
  F_OUT <= 1'b1;
  if((EN == 1'b1)&&(CLR == 1'b0)&&(Q0 < 4'b1001))
  begin
    Q0 <= Q0 + 4'b0001;
	F_OUT <= 1'b1;
  end
  else
  begin
	Q0 <= 4'b0000;
	if((EN == 1'b1)&&(CLR == 1'b0)&&(Q1 < 4'b1001))
	begin
	  Q1 <= Q1 + 4'b0001;
	  F_OUT <= 1'b1;
	end
	else
	begin
	  Q1 <= 4'b0000;
	  if((EN == 1'b1)&&(CLR == 1'b0)&&(Q2 < 4'b1001))
	  begin  
	    Q2 <= Q2 + 4'b0001;
	    F_OUT <= 1'b1;
	  end
	  else
	  begin
		Q2 <= 4'b0000;
		if((EN == 1'b1)&&(CLR == 1'b0)&&(Q3 < 4'b1001))
		begin  
		  Q3 <= Q3 + 4'b0001;
		  F_OUT <= 1'b1;
		end
		else
		begin
		  Q3 <= 4'b0000;
		  if((EN == 1'b1)&&(CLR == 1'b0)&&(Q4 < 4'b1001))
		  begin  
		    Q4 <= Q4 + 4'b0001;
		    F_OUT <= 1'b1;
		  end
		  else
		  begin
		    Q4 <= 4'b0000;
		    if((EN == 1'b1)&&(CLR == 1'b0)&&(Q5 < 4'b1001))
		    begin  
		      Q5 <= Q5 + 4'b0001;
		      F_OUT <= 1'b1;
		    end
		    else
		    begin
		      Q5 <= 4'b0000;
			  F_OUT <= 1'b1;
            end
          end
        end
      end
    end
  end
end
endmodule 