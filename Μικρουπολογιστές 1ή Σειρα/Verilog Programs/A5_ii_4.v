module A_3_25(A,B,C,D,F);

output F;
input A,B,C,D,E;

assign F = (!(!(!((!A)&&B))||(!(A&&(!B)))))&&(!(C||(!D)));

endmodule