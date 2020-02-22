package stx.run.head.data;

typedef Corridor<S,A,R,E> = A -> (R->S->Chomp<R,E>) -> (E->Chomp<R,E>) -> S -> Chomp<R,E>;