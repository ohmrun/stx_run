package stx.run.pack;

@:using(stx.run.pack.waiter.Implementation)
@:forward abstract Waiter<T,E>(WaiterDef<T,E>) from WaiterDef<T,E> to WaiterDef<T,E>{
  static public inline function _() return stx.run.pack.waiter.Constructor.ZERO;

  @:from static public function fromReceiverRes<T,E>(rcv:Receiver<Res<T,E>>):Waiter<T,E>{
    var recall : RecallDef<Noise,Res<T,E>,Automation>   = rcv;
    var waiter : Waiter<T,E>                                = (recall:Waiter<T,E>);
    return waiter;
  }
  static public function pure<T,E>(chk:Res<T,E>):Waiter<T,E>                             return _().pure(chk);

  static public function fromRes<T,E>(chk:Res<T,E>):Waiter<T,E>                      return _().fromRes(chk);

  static public function fromResReceiver<T,E>(rcv:Receiver<Res<T,E>>):Waiter<T,E>    return _().fromResReceiver(rcv);
  static public function fromReceiver<T>(rcv:Receiver<T>):Waiter<T,Dynamic>                  return _().fromReceiver(rcv);

  static public function feed<T,E>(fn:(Res<T,E>->Void)->Automation):Waiter<T,E>          return _().feed(fn);
  static public function into<T,E>(handler:(Res<T,E>->Void) -> Void):Waiter<T,E>         return _().into(handler);
  
  
  

  @:to public function toReceiver():Receiver<Res<T,E>>{
    return this;
  }
}