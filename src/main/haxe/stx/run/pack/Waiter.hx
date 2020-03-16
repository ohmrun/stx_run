package stx.run.pack;

@:using(stx.run.pack.waiter.Implementation)
@:forward abstract Waiter<T,E>(WaiterDef<T,E>) from WaiterDef<T,E> to WaiterDef<T,E>{
  static public inline function _() return stx.run.pack.waiter.Constructor.ZERO;

  @:from static public function fromReceiverOutcome<T,E>(rcv:Receiver<Outcome<T,E>>):Waiter<T,E>{
    var recall : RecallDef<Noise,Outcome<T,E>,Automation>   = rcv;
    var waiter : Waiter<T,E>                                = (recall:Waiter<T,E>);
    return waiter;
  }
  static public function pure<T,E>(chk:Outcome<T,E>):Waiter<T,E>                             return _().pure(chk);

  static public function fromOutcome<T,E>(chk:Outcome<T,E>):Waiter<T,E>                      return _().fromOutcome(chk);

  static public function fromOutcomeReceiver<T,E>(rcv:Receiver<Outcome<T,E>>):Waiter<T,E>    return _().fromOutcomeReceiver(rcv);
  static public function fromReceiver<T>(rcv:Receiver<T>):Waiter<T,Dynamic>                  return _().fromReceiver(rcv);

  static public function feed<T,E>(fn:(Outcome<T,E>->Void)->Automation):Waiter<T,E>          return _().feed(fn);
  static public function into<T,E>(handler:(Outcome<T,E>->Void) -> Void):Waiter<T,E>         return _().into(handler);
  
  
  

  @:to public function toReceiver():Receiver<Outcome<T,E>>{
    return this;
  }
}