package stx.run.pack.waiter;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();  
  public var _(default,never) = new Destructure();

  public function feed<T,E>(fn:(Outcome<T,E>->Void)->Automation):Waiter<T,E>{
    return Recall.Anon(
      (_,cb) -> {
        return fn(cb);
      }
    );
  }
  public function into<T,E>(handler:(Outcome<T,E>->Void) -> Void):Waiter<T,E>{
    return feed(
      (cb) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  public function fromOutcome<T,E>(chk:Outcome<T,E>):Waiter<T,E>{
    return into((cb) -> cb(chk));
  }
  inline public function pure<T,E>(chk:Outcome<T,E>):Waiter<T,E>{
    return fromOutcome(chk);
  }
  public function fromOutcomeReceiver<T,E>(rcv:Receiver<Outcome<T,E>>):Waiter<T,E>{
    return rcv;
  }
  public function fromReceiver<T>(rcv:Receiver<T>):Waiter<T,Dynamic>{
    return rcv.map(__.success).asRecallDef();
  }
}