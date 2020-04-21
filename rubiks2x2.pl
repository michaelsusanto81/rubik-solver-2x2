% %
% Solved state of cube
% A is top
% B is bottom
% C is left
% D is right
% E is front
% F is back
% %
:- include('show.pl').
:- initialization(show(cube(w, w, w, w, y, y, y, y, g, g, g, g, b, b, b, b, r, r, r, r, o, o, o, o))).
:- initialization(nl).
:- initialization(write('Halo selamat datang di game rubiks2x2.')).
:- initialization(nl).
:- initialization(write('Ketik "start." (tanpa petik) untuk memulai game.')).

solved(cube(A,A,A,A,B,B,B,B,C,C,C,C,D,D,D,D,E,E,E,E,F,F,F,F)).
solved(X) :- fail.
% Main logic
solve([], C, C).
solve([NR | R], C, Res) :- solve(R, Cur, Res), rotate(NR, C, Cur).

% Solver option
solve_one(Solution,C,Res) :- solve(Solution,C,Res), solved(Res), !.
solve_many(Solution,C,Res) :- solve(Solution,C,Res), solved(Res).

% %
% Rotations logic
% rotate(direction, fromState, toState)
% %
rotate(
	top,
	cube(
		W1,W2,W3,W4, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,G2,G3,G4, % left
		B1,B2,B3,B4, % right
		R1,R2,R3,R4, % front
		O1,O2,O3,O4  % back
	),
	cube(
		W3,W1,W4,W2, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,R1,G3,R2, % left
		O3,B2,O4,B4, % right
		B3,B1,R3,R4, % front
		O1,O2,G4,G2  % back
	)
).

rotate(
	bottom,
	cube(
		W1,W2,W3,W4, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,G2,G3,G4, % left
		B1,B2,B3,B4, % right
		R1,R2,R3,R4, % front
		O1,O2,O3,O4  % back
	),
	cube(
		W1,W2,W3,W4, % top
		Y2,Y4,Y1,Y3, % bottom
		R3,G2,R4,G4, % left
		B1,O1,B3,O2, % right
		R1,R2,B4,B2, % front
		G3,G1,O3,O4  % back
	)
).

rotate(
	left,
	cube(
		W1,W2,W3,W4, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,G2,G3,G4, % left
		B1,B2,B3,B4, % right
		R1,R2,R3,R4, % front
		O1,O2,O3,O4  % back
	),
	cube(
		O1,W2,O3,W4, % top
		R1,Y2,R3,Y4, % bottom
		G3,G1,G4,G2, % left
		B1,B2,B3,B4, % right
		W1,R2,W3,R4, % front
		Y1,O2,Y3,O4  % back
	)
).

rotate(
	right,
	cube(
		W1,W2,W3,W4, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,G2,G3,G4, % left
		B1,B2,B3,B4, % right
		R1,R2,R3,R4, % front
		O1,O2,O3,O4  % back
	),
	cube(
		W1,R2,W3,R4, % top
		Y1,O2,Y3,O4, % bottom
		G1,G2,G3,G4, % left
		B3,B1,B4,B2, % right
		R1,Y2,R3,Y4, % front
		O1,W2,O3,W4  % back
	)
).

rotate(
	front,
	cube(
		W1,W2,W3,W4, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,G2,G3,G4, % left
		B1,B2,B3,B4, % right
		R1,R2,R3,R4, % front
		O1,O2,O3,O4  % back
	),
	cube(
		W1,W2,G3,G4, % top
		B4,B3,Y3,Y4, % bottom
		G1,G2,Y2,Y1, % left
		B1,B2,W3,W4, % right
		R3,R1,R4,R2, % front
		O1,O2,O3,O4  % back
	)
).

rotate(
	back,
	cube(
		W1,W2,W3,W4, % top
		Y1,Y2,Y3,Y4, % bottom
		G1,G2,G3,G4, % left
		B1,B2,B3,B4, % right
		R1,R2,R3,R4, % front
		O1,O2,O3,O4  % back
	),
	cube(
		G1,G2,W3,W4, % top
		Y1,Y2,B2,B1, % bottom
		Y4,Y3,G3,G4, % left
		W1,W2,B3,B4, % right
		R1,R2,R3,R4, % front
		O2,O4,O1,O3  % back
	)
).
start :- assert(cube(y,o,r,g,b,r,o,o,g,o,r,y,b,b,r,w,b,y,w,g,w,w,g,y)),
		 inGame.

inGame :-cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4),
		 show(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
		 write('Silakan ketik move(arah_move) (pilih salah satu) untuk menyelesaikan rubik'),
		 nl.
finish :- cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4),
		  solved(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
		  show(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
		  write('Selamat Anda telah menyelesaikan game'),
		  !.
finish :- inGame.
move(Arah) :- rotate(Arah,cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4),Next), 
			  retract(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
			  assert(Next),
			  finish.