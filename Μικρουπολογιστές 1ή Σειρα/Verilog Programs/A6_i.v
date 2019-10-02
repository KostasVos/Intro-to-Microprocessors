module A_4_36(D,x,y,V);

output x,y,V;
input [0:3] D;
wire w1,w2;

not G1(w1,D[2]);
and G2(w2, w1, D[1]);

or
	G3(y, D[3], W2),
	G4(x, D[2], D[3]),
	G5(V, x, D[1], D[0]);

endmodule