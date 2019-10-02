module A_3_20b(A,B,C,D,F);

output F;
input A,B,C,D,E;

assign F = (!(!((!(!(C&&D)))||(!B))&&A))||(!(!(B&&(!C))));

endmodule