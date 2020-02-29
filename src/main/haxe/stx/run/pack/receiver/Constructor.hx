package stx.run.pack.receiver;

import stx.run.pack.receiver.Typedef in ReceiverT;

class Constructor{
  private function new(){}
  public function lift<T>(rcv:ReceiverT<T>):Receiver<T>{
    return new Receiver(rcv);
  }
  public function fromFuture<T>(ft:Future<T>):Receiver<T>{
    return lift((cb:T->Void) -> {
      return __.run().task(()->{},ft.handle(cb)).toAutomation();
    });
  }
  public function fromThunk<T>(ft:Thunk<T>):Receiver<T>{
    return lift((cb:T->Void) -> {
        cb(ft());
        return Automations.unit();
    });
  }
}