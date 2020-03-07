% Bruno Maglioni A01700879

% Helper predicates ---------------------
% Makes a stack.
stack(E, S, [E|S]).

% Checks if X is a member of the List.
member(X, [X|_]).

member(X, [_|T]):-
  member(X, T).

% Checks if E is a member of the Stack.
member_stack(E, S):-
  member(E, S).

% Empties the stack.
empty_stack([]).

% Prints the stack in reverse.
reverse_print_stack(S) :-
	empty_stack(S).

reverse_print_stack(S) :-
	stack(E, Rest, S),
	reverse_print_stack(Rest),
	write(E), nl.

% Separates the lists elements in two parts based on the pivot given.
pivoting(_, [], [], []).

pivoting(H, [X|T], [X|L], G):-
  X =< H,
  pivoting(H, T, L, G).

pivoting(H, [X|T], L, [X|G]):-
  X > H,
  pivoting(H, T, L, G).

% -------------------------------------

% Tree for LDFS
mov(a,b).
mov(a,c).
mov(b,d).
mov(b,e).
mov(c,f).
mov(c,g).
mov(d,h).
mov(e,i).
mov(e,j).

% go(Start, Goal, Limit)
% Realizes a  Limited Depth First Search from the Start to the Goal.
go(Start, Goal, Limit) :-
	empty_stack(Empty_been_list),
	stack(Start, Empty_been_list, Been_list),
	path(Start, Goal, Been_list, Limit).

path(Goal, Goal, Been_list, _) :-
	reverse_print_stack(Been_list).

path(State, Goal, Been_list, Limit) :-
	mov(State, Next),
	not(member_stack(Next, Been_list)),
  Limit >= 0,
	stack(Next, Been_list, New_been_list),
  NewLimit is Limit - 1,
	path(Next, Goal, New_been_list, NewLimit), !.


% quick_sort(List, Sorted)
% Unifies to Sorted the sorted list given.
% quick_sort([13, 46, 25, 12, 27, 1],  X). -> X = [1, 12, 13, 25, 27, 46]

quick_sort([], []).

quick_sort([H|T], Sorted):-
	pivoting(H,T,L1,L2),
	quick_sort(L1, Sorted1),
	quick_sort(L2, Sorted2),
	append(Sorted1, [H|Sorted2], Sorted).
