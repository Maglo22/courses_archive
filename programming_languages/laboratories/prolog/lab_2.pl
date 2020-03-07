% Bruno Maglioni A01700879

% Helper functions -------------
% Checks if lement exists on List.
exist(Element, [Element|_]).

exist(Element, [_|T]):-
  exist(Element, T).

% Appends two lists.
append2([], List, List).

append2([H|T], List2, [H|R]):-
append2(T, List2, R).

% -------------------------------

% any_positive(List)
% Unifies to true if there is at least one element in the list that is a
% positive number.
% any_positive([-1,-2,3,-4]). -> true

any_positive([H|T]):-
  H > 0;
  H < 0,
  any_positive(T).

% substitue(Element, Substitute, List, X)
% Substitutes the Element given with the Substitute in the List.
% Unifies the new list to X.
% substitute(2, 3, [1, 2, 2, 2, 3, 2], X). -> X = [1, 3, 3, 3, 3, 3]

substitute(_, _, [], []).

substitute(Element, Substitute, [Element|T], [Substitute|X]):-
  substitute(Element, Substitute, T, X).

substitute(Element, Substitute, [H|T], [H|X]):-
  substitute(Element, Substitute, T, X).

% eliminate_duplicates(List, X)
% Eliminates the dulpicates elements in a list.
% Unifies the new list to X.
% eliminate_duplicates([a, a, a, a, b, c, c, a, a, d, e, e, e, e], X). -> X = [a, b, c, d, e]

eliminate_duplicates([], []).

eliminate_duplicates([H|T], [H|X]):-
  eliminate(H, T, R),
  eliminate_duplicates(R, X).

eliminate_duplicates([_|T], X):-
  eliminate_duplicates(T, X).

eliminate(_, [], []).

eliminate(Element, [Element|T], R):-
  eliminate(Element, T, R).

eliminate(Element, [H|T], [H|R]):-
  Element \= H,
  eliminate(Element, T, R).


% intersect(List1, List2, X)
% Unifies to X a new list that has the elements that are present in both lists.
% intersect([a, b, c, d], [b, d, e, f], X). -> X = [b, d]

intersect([], _, []).
intersect(_, [], []).

intersect([H|T], List2, [H|X]):-
  exist(H, List2),
  intersect(T, List2, X).

intersect([_|T], List2, X):-
  intersect(T, List2, X).

% invert(List, X)
% Reverses the order of the list given.
% Unifies the new list to X.

invert([], []).

invert(List, X):-
  inv(List, [], X).

inv([], Acc, Acc):-!.

inv([H|T], Acc, X):-
  inv(T, [H|Acc], X).


% less_than(Pivot, List, X)
% Unifies to X a new list with the elements that are less than the Pivot.
% less_than(5, [1, 6, 5, 2, 7], X). -> X = [1, 2]

less_than(_, [], []).

less_than(Pivot, [H|T], [H|X]):-
  H < Pivot,
  less_than(Pivot, T, X).

less_than(Pivot, [_|T], X):-
  less_than(Pivot, T, X).

% more_than(Pivot, List, X)
% Unifies to X a new list with the elements that are more or equal than the Pivot.
% more_than(5, [1, 6, 5, 2, 7], X). -> X = [6, 5, 7]

more_than(_, [], []).

more_than(Pivot, [H|T], [H|X]):-
  H >= Pivot,
  more_than(Pivot, T, X).

more_than(Pivot, [_|T], X):-
  more_than(Pivot, T, X).

% rotate(List, N, X)
% Rotates the elements of the List N positions.
% Unifies the new list to X.
% rotate([1, 6, 5, 2, 7], 3, X). -> X = [2, 7, 1, 6, 5]
% rotate([1, 6, 5, 2, 7], -3, X). -> X = [5, 2, 7, 1, 6]

rotate(List, 0, List).

rotate([H|T], N, X):-
     N > 0,
     A is N - 1,
     append2(T, [H], NL),
     rotate(NL, A, X).

rotate(List, N, X):-
     N < 0,
     A is N * (-1),
     B is A-1,
     rotate(List, B, X).


% Modified to have bidirectional paths
road(genua, pisae).
road(pisae, genua).

road(pisae, roma).
road(roma, pisae).

road(placentia, ariminum).
road(ariminum, placentia).

road(ariminum, ancona).
road(ancona, ariminum).

road(ancona, roma).
road(roma, ancona).

road(ancona, castrum_truentinum).
road(castrum_truentinum, ancona).

road(castrum_truentinum, roma).
road(roma, castrum_truentinum).

road(brundisium, capua).
road(capua, brundisium).

road(capua, roma).
road(roma, capua).

road(messana, capua).
road(capua, messana).

road(rhegium ,messana).
road(messana ,rhegium).

road(lilibeum, messana).
road(messana, lilibeum).

road(catina, rhegium).
road(rhegium, catina).

road(syracusae, catina).
road(catina, syracusae).

% path(Origin, Destination, Path)
% Unifies to Path the path between Origin and Destination.
path(Origin, Destination, P) :-
  search_path(Origin, Destination, [Origin], N),
  invert(N, P).

search_path(Origin, Destination, Nodev, Pt) :-
  road(Origin, City),
  City \= Destination,
  not(member(City, Nodev)),
  search_path(City, Destination, [City|Nodev], Pt).

search_path(Origin, Destination, Pt, [Destination|Pt]) :-
  road(Origin, Destination).
