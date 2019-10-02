module A_4_45(D,x,y,V);

output [0:1] out, V;
input [0:3] D;
reg [0:1] out, V;

always @(D)
	begin
		if(D[0])
			begin
				out[0]=1;
				out[1]=1;
			end
		
		else if(D[1])
			begin
				out[0]=1;
				out[1]=0;
			end
		
		else if(D[2])
			begin
				out[0]=0;
				out[1]=1;
			end
			
		else if(D[3])
			begin
				out[0]=0;
				out[1]=0;
			end
		
		if(D) V=1;
		else  V=0;
	end

endmodule