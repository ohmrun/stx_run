package stx.run.head;

import stx.run.head.data.Receiver in ReceiverT;

class Receivers{
  @:noUsing static public function lift<T>(rcv:ReceiverT<T>):Receiver<T>{
    return new Receiver(rcv);
  }
  @:noUsing static public function fromFuture<T>(ft:Future<T>):Receiver<T>{
    return lift((cb:T->Void) -> {
      return __.run().task(()->{},ft.handle(cb)).toAutomation();
    });
  }
  @:noUsing static public function fromThunk<T>(ft:Thunk<T>):Receiver<T>{
    return lift((cb:T->Void) -> {
        cb(ft());
        return Automations.unit();
    });
  }
  //@:noUsing static  
}