% maximal_intervals(S, E, Intervals)
%   Δημιουργεί "μέγιστα" διαστήματα [s,e] από τις λίστες S και E 
%   οι οποίες ΠΡΕΠΕΙ να είναι ταξινομημένες
maximal_intervals(S, E, Intervals) :-
    do_subtract(E, S, E_without_S),
    build_intervals(S, E_without_S, Intervals).

% build_intervals(S, E_without_S, Intervals)
%   Διατρέχει τη λίστα S και για κάθε στοιχείο της Hs,
%   καλεί next_break/3 για να βρει το πρώτο στοιχείο της E_without_S που είναι > Hs.
%   Παράγει ένα διάστημα [Hs, Te].
%   Κατόπιν, με την greater_than/3 προσπερνά στην S τα στοιχεία < Te. 
%   Επαναλαμβάνει μέχρι να εξαντληθεί η S.
build_intervals([], _, []).
build_intervals([Hs|Ts], E_without_S, [[Hs, Te] | Intervals]) :-
    next_break(Hs, E_without_S, Te),
    greater_than(Ts, Te, TsAfter),
    build_intervals(TsAfter, E_without_S, Intervals).

% next_break(Hs, E_without_S, Te)
%   Επιστρέφει στο Te το πρώτο στοιχείο της E_without_S που είναι > Hs.
%   Αν δεν υπάρχει, Te = inf (όπου το inf είναι συμβολική τιμή που αναπαριστά το άπειρο).
next_break(_, [], inf).
next_break(Hs, [X|_], X) :-
    X > Hs.
next_break(Hs, [X|Xs], Te) :-
    X =< Hs,
    next_break(Hs, Xs, Te).

% do_subtract(L1, L2, Result)
%   Αφαιρεί από τη λίστα L1 τα στοιχεία που εμφανίζονται στη λίστα L2.
%   Οι λίστες ΠΡΕΠΕΙ να είναι ταξινομημένες. Το αποτέλεσμα είναι η λίστα Result.
do_subtract([], _, []).
do_subtract(L, [], L).
do_subtract([X|Xs], [Y|Ys], R) :-
    X == Y,
    do_subtract(Xs, Ys, R).
do_subtract([X|Xs], [Y|Ys], [X|R]) :-
    X < Y,
    do_subtract(Xs, [Y|Ys], R).
do_subtract([X|Xs], [Y|Ys], R) :-
    X > Y,
    do_subtract([X|Xs], Ys, R).

% greater_than(S, Te, SAfter)
%   Παίρνει τη λίστα S, και "πετάει" όλα τα στοιχεία < Te.
%   Μόλις βρει στοιχείο >= Te, σταματά και τα επιστρέφει ως SAfter.
greater_than([], _, []).
greater_than(_, inf, []).
greater_than([X|Xs], Y, [X|Zs]) :- X >= Y,
    greater_than(Xs, Y, Zs).
greater_than([X|Xs], Y, Zs) :- X < Y,
    greater_than(Xs, Y, Zs).