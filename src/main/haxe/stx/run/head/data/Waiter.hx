package stx.run.head.data;

import stx.run.head.data.Receiver in ReceiverT;

typedef Waiter<R,E> = ReceiverT<Chunk<R,E>>;