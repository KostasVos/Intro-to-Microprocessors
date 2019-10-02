module A_3_21b(A,B,C,D,F);

output F;
input A,B,C,D;
wire w1,w2,w3,w4,w5,Anot, Bnot, Cnot;

not
	G1 (Anot, A),
	G2 (Bnot, B),
	G3 (Cnot, C);


nand
	G4 (w1, A, Bnot),
	G5 (w2, Anot, B),
	G6 (w3, Cnot, D),
	G7 (w4, w1, w2),
	G8 (w5, w3, w4);
	
not G9(F, w5)



endmodule