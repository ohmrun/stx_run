package stx.run.module;

import stx.run.head.data.Waiter in WaiterT;

class Waiters extends Clazz{
  public function lift<T,E>():Unary<WaiterT<T,E>,Waiter<T,E>>{
    return (rcv) -> new Waiter(rcv);
  }
}