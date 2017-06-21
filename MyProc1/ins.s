H:	LDI r1, 1	;hi
	LDI r2, 2
	ADD r3, r2, r1
	BEQ r1, r2, H
L2:	HALT
	J L2