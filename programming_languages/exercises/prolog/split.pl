split([], [], []).
split([H], [H], []).

split([H1,H2|T], [H1|T1], [H2|T2]):-
	split(T, T1, T2).