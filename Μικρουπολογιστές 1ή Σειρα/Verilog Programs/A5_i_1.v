module A_3_20a(A,B,C,D,F);

output F;
input A,B,C,D;
wire w1,w2,w3,w4,w5;

not G1(w1, C);

and G2(w2, C, D);
or G3(w3, w2, B);
and G4(w4, w3, A);
and G5 (w5, w1, B);

or G6(F, w4, w50);

endmodule