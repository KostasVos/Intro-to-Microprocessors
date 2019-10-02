module A_3_24(A,B,C,D,E,F);

output F;
input A,B,C,D,E;

assign F = (!(!(A||B)))&&(!(!(C||D)))&&(!(!(E)))

endmodule