module A_3_24(A,B,C,D,E,F);

output F;
input A,B,C,D,E;
wire w1,w2,Enot;

not	G1(Enot, E);

nor
	G2(w1, A, B),
	G3(w2, C, D),
	G4(F, w1, w2, Enot);

endmodule