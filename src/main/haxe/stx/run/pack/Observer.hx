package stx.run.pack;


import stx.run.head.data.Observer in ObserverT;

@:forward @:callable abstract Observer<T>(ObserverT<T>) to ObserverT<T>{
  private function new(self) this = self;
  @:noUsing static public function lift<T>(obs:ObserverT<T>):Observer<T>{
    return new Observer(obs);
  }
  @:noUsing static public function pure<T>(v:T):Observer<T>{
    return lift((cb) -> {
      cb(v);
    });
  }
  public inline function map<U>(fn:T->U){
    return (cb:U->Void) -> this((t:T) -> cb(fn(t)));
  }

  public function prj():ObserverT<T>{
    return this;
  }
  public function toReceiver():Receiver<T>{
    return Receiver.lift((cont) -> {
      return __.run().perform(this.bind(cont));
    });
  }
}