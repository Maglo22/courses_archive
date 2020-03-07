appears(chuck_norris, delta_force).
appears(chuck_norris, way_of_the_dragon).
appears(jackie_chan, the_foreigner).
appears(jackie_chan, rush_hour).
appears(bruce_lee, enter_the_dragon).
appears(bruce_lee, way_of_the_dragon).

year(rush_hour, 2003).

share(Actor1, Actor2) :-
	appears(Actor1, Movie),
	appears(Actor2, Movie).

actor_year(Actor, Year, Movie):-
	appears(Actor, Movie),
	year(Movie, Year).