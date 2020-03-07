% Bruno Maglioni A01700879

% Knowledge Base

% Ex_1
hobby(juan,kaggle).
hobby(luis,hack).
hobby(elena,tennis).
hobby(midori,videogame).
hobby(simon,sail).
hobby(simon,kaggle).
hobby(laura,hack).
hobby(hans,videogame).

% Ex_2
road(genua, pisae).
road(pisae, roma).
road(placentia, ariminum).
road(ariminum, ancona).
road(ancona, roma).
road(castrum_truentinum, roma).
road(brundisium, roma).
road(capua, roma).
road(messana, capua).
road(rhegium ,messana).
road(lilibeum, messana).
road(catina, rhegium).
road(syracusae, catina).

% Rules

% compatible(Person1, Person2)
% Two persons are compatible if they share at least 1 hobby.
% compatible(juan, simon) -> true
compatible(Person1, Person2):-
	hobby(Person1, Hobby),
	hobby(Person2, Hobby).

% can_get_to(Origin, Destination)
% Unifies to true if there is a path from the Origin to the Destination specified (taking into account directionality).
% can_get_to(lilibeum, capua) -> true
can_get_to(Origin, Destination):-
	road(Origin, Destination).

can_get_to(Origin, Destination):-
    road(Origin, Stop),
    can_get_to(Stop, Destination).

% size(Origin, Destination, Z)
% Unifies to Z the number of cities visited from the Origin to the Destination given.
% size(lilibeum, capua, Z) -> Z = 1
size(Origin, Destination, Z):-
    size(Origin, Destination, 0, Z).

size(_Origin, _Destination, Z, Z):-!.

size (Origin, Destination, Ac, Z):-
  NewAc is Ac + 1,
	road(Origin, Stop),
	size(Stop, Destination, NewAc, Z).

% min(A, B, C, Z)
% Unifies to Z the minimal value between A, B and C.
% min(4, 1, 2, Z) -> Z = 1
min(A, B, C, Z):-
	A < B,
	A < C,
	Z is A;
	B < A,
	B < C,
	Z is B;
    C < A,
    C < B,
	Z is C.

% gcd(A, B, Z)
% Unifies to Z the greatest common divisor between A and B.
% gcd(27, 9, Z) -> Z = 9
gcd(A, 0, A).

gcd(A, B, Z):-
	M is A mod B,
	gcd(B, M, Z).
