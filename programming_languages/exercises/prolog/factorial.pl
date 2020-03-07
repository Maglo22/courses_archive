factH(1, 1).

factH(Number, Factorial) :-
	N1 is Number - 1,
	factH(N1, F1),
	Factorial is Number * F1.


factT(Number, Factorial) :-
	factT(Number, 0, 1, Factorial).

factT(0, _, Fac, Fac):-!.

factT(Number, Counter, Aux, Factorial):-
	Number > 0,
	N1 is Number - 1,
	CT is Counter + 1,
	NewAux is CT * Aux,
	factT(N1, CT, NewAx, Fac).