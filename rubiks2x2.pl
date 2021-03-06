:- include('show.pl').
:- initialization(show(cube(w, w, w, w, y, y, y, y, g, g, g, g, b, b, b, b, r, r, r, r, o, o, o, o))).
:- initialization(nl).
:- initialization(write('Welcome to 2x2 Rubiks game!')).
:- initialization(nl).
:- initialization(write('Made by:')).
:- initialization(nl).
:- initialization(write('Adrian Wijaya - 1806205363 - mon23c (github)')).
:- initialization(nl).
:- initialization(write('Michael Susanto - 1806205653 - michaelsusanto81 (github)')).
:- initialization(nl).
:- initialization(nl).
:- initialization(write('Server is running on port 5000 . . .')).
:- initialization(nl).
:- initialization(nl).
:- dynamic cube/24.
:- dynamic turn/1.
:- dynamic gameOver/0.

% %
% Solved state of cube
% Description: iff every face of the cube is already the same color
% A is top
% B is bottom
% C is left
% D is right
% E is front
% F is back
% %
solved(cube(A,A,A,A,B,B,B,B,C,C,C,C,D,D,D,D,E,E,E,E,F,F,F,F)).
solved(_) :- fail.

% %
% Main logic of solver
% Description:
% 		- There is no need to give solution list of moves of there are no any moves left to solve the 'Cube' 
% 		- The rubik 'Cube' is searching list of moves '[NextRot|Rot]' to solve the 'Cube' state to the 'Res' state
% 		  if there is a list of next moves ('Rot') of the 'Cur' state to the 'Res' state
% 		  then do rotate from 'Cube' state to 'Cur' state with 'NextRot'
% 		- There is only one 'Solution' (list moves) from the 'Cube' state to the 'Res' state
% 		  if there is a list of 'Solution' from 'Cube' to 'Res', and 'Res' is the solved state of cube
% %
solve([], Cube, Cube).
solve([NextRot | Rot], Cube, Res) :- solve(Rot, Cur, Res), rotate(NextRot, Cube, Cur).	
solve_one(Solution,Cube,Res) :- solve(Solution,Cube,Res), solved(Res), !.

% %
% Rotations logic
% Description: rotate(direction, fromState, toState)
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

% %
% Set difficulty
% Description: set 100/75/50 turns then start inGame
% %
difficulty(easy) :- turn(_), retractall(turn(_)), start, fail.					% '/easy' frontend exception handler
difficulty(easy) :- assert(turn(100)), inGame.
difficulty(medium) :- turn(_), retractall(turn(_)), start, fail.				% '/medium' frontend exception handler
difficulty(medium) :- assert(turn(75)), inGame.
difficulty(hard) :- turn(_), retractall(turn(_)), start, fail.					% '/hard' frontend exception handler
difficulty(hard) :- assert(turn(50)), inGame.

% %
% Some in-game commands
% Description:
% 		- start: preparing cube and hint before start
% 		- restart: restart the game
% 		- inGame: if there is no turns left, gameOver and do cleaning. Otherwise do nothing
% 		- finish: if the cube is solved, then do cleaning. Otherwise is still inGame
% 		- undo: update hint, cube, lastMove, turn
% 				undo is do rotate 3 times of lastMove
% 		- move: update hint, cube, lastMove, turn. Then do rotate
% 		- exit: terminates server
% %
start :- retractall(gameOver),
		 cube(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),					% '/start' frontend exception handler
		 retractall(cube(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
		 retractall(hint(_)),
		 retractall(turn(_)),
		 retractall(lastMove(_)),
		 fail.
start :- assert(cube(y,o,r,g,b,r,o,o,g,o,r,y,b,b,r,w,b,y,w,g,w,w,g,y)),
		 assert(hint(Direction) :-
		 	solve_one([Direction|_],cube(y,o,r,g,b,r,o,o,g,o,r,y,b,b,r,w,b,y,w,g,w,w,g,y),_)
		 ),
		 assert(lastMove(none)),
		 !.

restart :- start.

inGame :- turn(0),
		assert(gameOver),
		retract(cube(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	    retract(hint(_) :- solve_one(_,_,_)),
	    retract(turn(_)),
	    retract(lastMove(_)),
		!.

inGame :- turn(_),
		 cube(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
		 !.

finish :- cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4),
		  solved(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
		  retract(cube(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
		  retract(hint(_) :- solve_one(_,_,_)),
		  retract(turn(_)),
		  retract(lastMove(_)),
		  !.

finish :- inGame,!.

undo :- lastMove(none),!.												% '/undo' frontend exception handler
undo :- turn(Remaining),
		NewRemaining is Remaining + 1,
		retract(turn(_)),
		assert(turn(NewRemaining)),
		lastMove(Direction),
		rotate(Direction,cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4),UndoOne),
		rotate(Direction,UndoOne,UndoTwo),
		rotate(Direction,UndoTwo,UndoFinal),
		retract(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
		retract(hint(_) :- solve_one(_,_,_)),
		assert(UndoFinal),
		assert(hint(NextDir) :- solve_one([NextDir|_],UndoFinal,_)),
		retract(lastMove(_)),
		assert(lastMove(none)),
		finish,
		!.

move(_) :- \+cube(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),!.	% '/front', '/top', '/right' frontend exception handler
move(Direction) :- turn(Remaining),
			  NewRemaining is Remaining - 1,
			  retract(turn(_)),
			  assert(turn(NewRemaining)),
			  rotate(Direction,cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4),Next), 
			  retract(cube(W1,W2,W3,W4,Y1,Y2,Y3,Y4,G1,G2,G3,G4,B1,B2,B3,B4,R1,R2,R3,R4,O1,O2,O3,O4)),
			  retract(hint(_) :- solve_one(_,_,_)),
			  assert(Next),
			  assert(hint(NextDir) :- solve_one([NextDir|_],Next,_)),
			  retract(lastMove(_)),
			  assert(lastMove(Direction)),
			  finish,
			  !.

exit :- halt(0).