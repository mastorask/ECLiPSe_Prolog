:- lib(ic).
:- lib(branch_and_bound).

% color_graph/4: Δημιουργεί γράφο με N κόμβους και πυκνότητα D, και βρίσκει τον ελάχιστο χρωματισμό
color_graph(N, D, Col, C) :-
    % Δημιουργία γράφου με N κόμβους και πυκνότητα D
    create_graph(N, D, Edges),
    % Το μέγεθος της λίστας χρωμάτων πρέπει να έχει N στοιχεία
    length(Col, N),
    % Κάθε κόμβος παίρνει χρώμα από 1 έως N
    Col :: [1..N],
    % Όλοι οι γειτονικοί κόμβοι πρέπει να έχουν διαφορετικά χρώματα
    impose_constraints(Edges, Col),
    % C είναι ο μέγιστος αριθμός στη λίστα χρωμάτων Col
    maxlist(Col, C),
    % Δυναμική ανάθεση χρωμάτων στους κόμβους με στόχο την ελαχιστοποίηση του μέγιστου χρώματος C
    minimize(labeling(Col), C),
    % Σε κάποιες σπάνιες περιπτώσεις παρατήρησα τη labeling να μην επιβάλλει όλους τους περιορισμούς
    verify_constraints(Edges, Col).

% impose_constraints/2: Επιβάλλει περιορισμούς ώστε γειτονικοί κόμβοι να έχουν διαφορετικά χρώματα
impose_constraints([], _).
impose_constraints([X - Y|Edges], Col) :-
    element(X, Col, Cx), % Το Cx είναι το χρώμα του κόμβου X
    element(Y, Col, Cy), % Το Cy είναι το χρώμα του κόμβου Y
    Cx #\= Cy,           % Ισχύει Cx <> Cy ακέραιες διαφορετικές τιμές
    impose_constraints(Edges, Col). % συνέχεια με τους υπόλοιπες ακμές στη λίστα Edges

% verify_constraints/2: Ελέγχει αν οι περιορισμοί ισχύουν για τον τελικό χρωματισμό
verify_constraints([], _).
verify_constraints([X - Y|Edges], Col) :-
    element(X, Col, Cx), % Το Cx είναι το χρώμα του κόμβου X
    element(Y, Col, Cy), % Το Cy είναι το χρώμα του κόμβου Y
    Cx \= Cy, % Χρησιμοποιείται \= αντί #\= μια και πλέον η IC δεν είναι απαραίτητη
    verify_constraints(Edges, Col). % συνέχεια με τους υπόλοιπες ακμές στη λίστα Edges

% create_graph/3: Δημιουργεί έναν τυχαίο γράφο με NNodes κόμβους και πυκνότητα Density
create_graph(NNodes, Density, Graph) :-
    cr_gr(1, 2, NNodes, Density, [], Graph).

% cr_gr/6: Βοηθητικό κατηγόρημα για τη δημιουργία γράφου
cr_gr(NNodes, _, NNodes, _, Graph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
    N1 < NNodes,
    N2 > NNodes,
    NN1 is N1 + 1,
    NN2 is NN1 + 1,
    cr_gr(NN1, NN2, NNodes, Density, SoFarGraph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
    N1 < NNodes,
    N2 =< NNodes,
    rand(1, 100, Rand),
    (Rand =< Density ->
        append(SoFarGraph, [N1 - N2], NewSoFarGraph) ;
        NewSoFarGraph = SoFarGraph),
    NN2 is N2 + 1,
    cr_gr(N1, NN2, NNodes, Density, NewSoFarGraph, Graph).

% rand/3: Παράγει τυχαίο αριθμό μεταξύ N1 και N2
rand(N1, N2, R) :-
    random(R1),
    R is R1 mod (N2 - N1 + 1) + N1.