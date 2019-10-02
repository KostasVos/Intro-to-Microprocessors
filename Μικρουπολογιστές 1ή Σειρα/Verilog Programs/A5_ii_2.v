module A_3_21a(A,B,C,D,F);

output F;
input A,B,C,D;

assign F = ((A&&(!B))||((!A)&&B))&&(C||(!D));

endmodule