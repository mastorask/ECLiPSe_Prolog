:- module(parser, [
    read_definitions/4
]).

% === Δηλώνουμε τον τελεστή := για να διαβάζεται σωστά από το αρχείο ===
:- op(1200, xfx, :=).

% === read_definitions(+File, -InputEvents, -EventDefs, -StateDefs) ===
read_definitions(File, InputEvents, EventDefs, StateDefs) :-
    open(File, read, Stream),
    read_all_terms(Stream, Terms),
    close(Stream),
    partition_terms(Terms, InputEvents, EventDefs, StateDefs).

% === read_all_terms(+Stream, -Terms) ===
read_all_terms(Stream, []) :-
    at_end_of_stream(Stream), !.
read_all_terms(Stream, [Term | Rest]) :-
    read(Stream, Term),
    Term \= end_of_file,
    read_all_terms(Stream, Rest).

% === partition_terms(+Terms, -Inputs, -Events, -States) ===
partition_terms([], [], [], []).
partition_terms([Term | Rest], [Ev | Inputs], Events, States) :-
    Term = input_event_declaration(Ev),
    partition_terms(Rest, Inputs, Events, States).
partition_terms([event_def Ev := Formula | Rest], Inputs, [Ev := Formula | Events], States) :-
    partition_terms(Rest, Inputs, Events, States).
partition_terms([state_def Ev := Formula | Rest], Inputs, Events, [Ev := Formula | States]) :-
    partition_terms(Rest, Inputs, Events, States).
partition_terms([_ | Rest], Inputs, Events, States) :-
    % Αγνόησε ό,τι δεν αναγνωρίζεται
    partition_terms(Rest, Inputs, Events, States).