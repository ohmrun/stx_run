package stx.run.pack;

@:using(stx.run.pack.Waiter.WaiterLift)
@:forward abstract Waiter<T,E>(WaiterDef<T,E>) from WaiterDef<T,E> to WaiterDef<T,E>{
  static public var _(default,never) = WaiterLift;

  @:from static public function fromReceiverRes<T,E>(rcv:Receiver<Res<T,E>>):Waiter<T,E>{
    var recall : RecallDef<Noise,Res<T,E>,Automation>   = rcv;
    var waiter : Waiter<T,E>                                = (recall:Waiter<T,E>);
    return waiter;
  }
  static public function feed<T,E>(fn:(Res<T,E>->Void)->Automation):Waiter<T,E>{
    return Recall.Anon(
      (_,cb) -> {
        return fn(cb);
      }
    );
  }
  static public function into<T,E>(handler:(Res<T,E>->Void) -> Void):Waiter<T,E>{
    return feed(
      (cb) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  static public function fromRes<T,E>(chk:Res<T,E>):Waiter<T,E>{
    return into((cb) -> cb(chk));
  }
  static public function pure<T,E>(chk:Res<T,E>):Waiter<T,E>{
    return fromRes(chk);
  }
  static public function fromResReceiver<T,E>(rcv:Receiver<Res<T,E>>):Waiter<T,E>{
    return rcv;
  }
  static public function fromReceiver<T>(rcv:Receiver<T>):Waiter<T,Dynamic>{
    return rcv.map(__.success).asRecallDef();
  }
  @:to public function toReceiver():Receiver<Res<T,E>>{
    return this;
  }
}  
class WaiterLift{
  
  static public function map<T,TT,E>(self:Waiter<T,E>,fn:T->TT):Waiter<TT,E>{
    return Waiter.feed(
      (cb:Res<TT,E>->Void) -> self.applyII(Noise,
        (oc:Res<T,E>) -> cb(oc.map(fn))
      ) 
    );
  }
  static public function flat_map<T,TT,E>(self:Waiter<T,E>,fn:T->Waiter<TT,E>):Waiter<TT,E>{
    return Recall.Anon(
      (_:Noise,cb:Res<TT,E>->Void) -> self.applyII(Noise,
        (ocT:Res<T,E>) -> ocT.fold(
          (t) -> fn(t).applyII(Noise,cb),
          (e) -> {
            cb(__.failure(e));
            return Automation.unit();
          }
        )
      )
    );
  }
  static public function fold<T,TT,E>(self:Waiter<T,E>,val:T->TT,err:Err<E>->TT):Receiver<TT>{
    return Receiver._.map(
      self.toReceiver(),
      Outcome._.fold.bind(_,val,err)
    );
  }
  public function errata<T,E,EE>(self:Waiter<T,E>,fn:Err<E>->Err<EE>):Waiter<T,EE>{
    return Waiter.fromReceiverRes(Receiver._.map(
      self.toReceiver(),
      (oc:Res<T,E>) -> oc.errata(fn)
    ));
  }
}