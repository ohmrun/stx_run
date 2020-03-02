package stx.run.pack.waiter;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  
  public var _(default,never) = new Destructure();

  public function feed<T,E>(fn:(Outcome<T,E>->Void)->Automation):WaiterDef<T,E>{
    return Recall.anon(
      (_,cb) -> {
        return fn(cb);
      }
    );
  }
  public function into<T,E>(handler:(Outcome<T,E>->Void) -> Void):WaiterDef<T,E>{
    return feed(
      (cb) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  public function fromOutcome<T,E>(chk:Outcome<T,E>):WaiterDef<T,E>{
    return into((cb) -> cb(chk));
  }
  inline public function pure<T,E>(chk:Outcome<T,E>):WaiterDef<T,E>{
    return fromOutcome(chk);
  }
  public function fromOutcomeReceiver<T,E>(rcv:ReceiverDef<Outcome<T,E>>):WaiterDef<T,E>{
    return rcv;
  }
  public function fromReceiver<T>(rcv:ReceiverDef<T>):WaiterDef<T,Dynamic>{
    return rcv.map(__.success).prj();
  }
}