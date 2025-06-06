%   Ελέγχει ότι τα δύο πρώτα στοιχεία είναι αυστηρά αυξανόμενα (X < Y)
%   και συνεχίζει στην "αναρρίχηση" με ascend(Y, Rest).
mountain([X,Y|Rest]) :-
    X < Y,
    ascend(Y, Rest).

% Εάν Prev < X, συνεχίζουμε την άνοδο.
ascend(Prev, [X|Rest]) :-
    Prev < X,
    ascend(X, Rest).

% Εάν Prev > X, ξεκινάμε τη φάση καθόδου με descend(X, Rest).
ascend(Prev, [X|Rest]) :-
    Prev > X,
    descend(X, Rest).

descend(_, []) :-
    true.

% Εάν Prev > X, συνεχίζουμε την κάθοδο.
descend(Prev, [X|Rest]) :-
    Prev > X,
    descend(X, Rest).
