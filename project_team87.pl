
build_kb:-
	write('Please enter a word and its category on separate lines'),nl,
	read(X), 
	( X=done ; 
	read(C), assert(word(X,C)), build_kb).


is_category(C):-
	word(_,C).

categories(L):-
	setof(C, is_category(C),L).

available_length(Y):-  
	word(X,_),
	atom_chars(X,L),
	length(L,Y).

available_length(X,Y):- 
	atom_chars(X,L),
	length(L,Y).

pick_word(W,Y,C):- 
	word(W,C),
	available_length(W,Y).

intersect([X|Y],M,[X|Z]) :- member(X,M), delete(M,X,M1), intersect(Y,M1,Z).
intersect([X|Y],M,Z) :- \+ member(X,M), intersect(Y,M,Z).
intersect([],_,[]).

correct_letters(L1,L2,CL):-
	intersect(L1,L2,CL).


correct_positions([],[],[]).

correct_positions([H|T],[H|T1],[H|T2]):-
	correct_positions(T,T1,T2).

correct_positions([H|T],[H1|T1],PL):-
	H\=H1,
	correct_positions(T,T1,PL).

choose_category:-
	write('Choose a category:'),nl,
	read(C),
	((is_category(C),choose_length(C));
	(write('This category does not exist'),nl,
	choose_category)).

choose_length(C):-
	write('Choose a length:'),nl,
	read(N),
	((pick_word(_,N,C),
	random_word(N,C,_,Random),
	Guesses is N+1,
	write('Game started. You have '), write(Guesses),write(' guesses'),nl,
	play(Random,Guesses));
	(write('There are no words of this length. '),nl,choose_length(C))).

play(Random,Guesses):-
	write('Enter a word composed of  '),available_length(Random,Y),write(Y),write(' letters.'),nl,
	read(Word),
	((Guesses==1,Word\=Random,write('You lost :( ')); 
	(Guesses>1,Word\=Random,available_length(Word,Y1),Y==Y1,atom_chars(Word,L1),atom_chars(Random,L2),
	write('Correct letters are: '),correct_letters(L2,L1,CL),write(CL),nl,
	write('Correct positions are: '),correct_positions(L2,L1,PL),write(PL),nl,
	Guesses1 is Guesses - 1,
	write('Remaining guesses are '),write(Guesses1),nl,
	play(Random,Guesses1));
	(Guesses>1,Word\=Random,available_length(Word,Y1),Y\=Y1,
	write('Word is not composed of '),write(Y),write(' letters. Try agian!'),nl,
	write('Remaining guesses are '),write(Guesses),nl,
	play(Random,Guesses));
	(Guesses>0,Random==Word,write('YOU WON BESTIE !'))).

random_word(N,C,L,Random):- 
	setof(W,pick_word(W,N,C),L),
	random_member(Random,L).


play:-
	write('Available categories are:'),categories(L),write(L),nl,
	choose_category.
	
	
	

main:-

write('Welcome'), nl,

build_kb,

play.
