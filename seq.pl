% seq(S, E, Intervals)
%   Διατρέχει ταξινομημένες λίστες S και E, δημιουργώντας "διαστήματα" [s,e], όπου e > s,
%   και δεν παρεμβάλλεται κανένα άλλο στοιχείο μεταξύ s και e.
%   Χρησιμοποιεί το seq_helper/4 με αρχικό Start = none, υποδηλώνοντας ότι αναζητείται το επόμενο s.
seq(S, E, Intervals) :-
    seq_helper(S, E, none, Intervals).


% seq_helper(S, E, Start, Intervals)
%   - S, E: οι λίστες όπως έχουν διαμορφοθεί μέχρι τώρα.
%   - Start: είτε none, είτε X, όπου X είναι το τρέχων "εντοπισμένο" στη λίστα S.
%   - Intervals: λίστα των διαστημάτων που παράγονται.

% -------------------------------------------------

% Όταν ΚΑΙ οι δύο λίστες είναι άδειες δεν υπάρχουν διαστήματα.
seq_helper([], [], _, []).

% Όταν S άδεια, E μη άδεια, Start = none, δεν μπορεί να δημιουργηθεί διάστημα.
seq_helper([], [_|_], none, []).

% Όταν S άδεια, αλλά έχουμε "εντοπισμένο" Start = X. Αν βρούμε EHead > X, φτιάχνουμε [X, EHead].
seq_helper([], [EHead|ETail], X, [[X, EHead]|Intervals]) :-
    EHead > X,
    seq_helper([], ETail, none, Intervals).

% ... Αν EHead =< X, αγνοούμε το EHead και συνεχίζουμε.
seq_helper([], [EHead|ETail], X, Intervals) :-
    EHead =< X,
    seq_helper([], ETail, X, Intervals).

% Όταν S μη άδεια, E άδεια, δεν μπορεί να δημιουργηθεί διάστημα.
seq_helper([_|_], [], _, []).

% -------------------------------------------------

% Όταν ΚΑΙ οι δύο λίστες έχουν στοιχεία, Start = none.
% ... Αν S < E κρατάμε ως "εντοπισμένο" Start το επόμενο S.
seq_helper([SHead|STail], [EHead|ETail], none, Intervals) :-
    SHead < EHead,
    seq_helper(STail, [EHead|ETail], SHead, Intervals).

% ... Αν S == E, τα προσπερνάμε.
seq_helper([SHead|STail], [EHead|ETail], none, Intervals) :-
    SHead == EHead,
    seq_helper(STail, ETail, none, Intervals).

% ... Αν S > E, προσπερνάμε το E.
seq_helper([SHead|STail], [EHead|ETail], none, Intervals) :-
    SHead > EHead,
    seq_helper([SHead|STail], ETail, none, Intervals).

% -------------------------------------------------

% Όταν KAI οι δύο λίστες έχουν στοιχεία, Start = X.
% ... Αν EHead > X και EHead < SHead, σχηματίζουμε [X, EHead].
seq_helper([SHead|STail], [EHead|ETail], X, [[X, EHead]|Intervals]) :-
    EHead > X,
    EHead < SHead,
    seq_helper([SHead|STail], ETail, none, Intervals).

% ... Αν EHead <= X, το αγνοούμε.
seq_helper(S, [EHead|ETail], X, Intervals) :-
    EHead =< X,
    seq_helper(S, ETail, X, Intervals).

% ... Αν SHead <= EHead, εμφανίστηκε νέο S πριν βρούμε EHead > X,
%     οπότε "ακυρώνουμε" το παλιό X και κρατάμε το SHead ως νέο Start.
seq_helper([SHead|STail], [EHead|ETail], _, Intervals) :-
    SHead =< EHead,
    seq_helper(STail, [EHead|ETail], SHead, Intervals).