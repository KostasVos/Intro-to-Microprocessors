module A_3_25(A,B,C,D,F);

output F;
input A,B,C,D,E;
wire w1,w2,w3,w4,Anot,Bnot,Dnot;

not	
	G1(Anot, A),
	G2(Bnot, B),
	G3(Dnot, D);

nor
	G4(w1, Anot, B),
	G5(w2, A, Bnot),
	G6(w3, C, Dnot),
	G7(w4, w1, w2),
	G8(F, w4,w3);

endmodule