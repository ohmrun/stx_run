package stx.run.head.data;

import stx.run.head.data.Waiter in WaiterT;

typedef IO<O,E> = Unary<Automation,WaiterT<O,E>>;