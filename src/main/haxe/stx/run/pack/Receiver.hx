package stx.run.pack;

@:using(stx.run.pack.Receiver.ReceiverLift)
@:forward abstract Receiver<T>(ReceiverDef<T>) from ReceiverDef<T> to ReceiverDef<T>{
  static public var _(default,never) = ReceiverLift;

  static public function into<T>(handler:(T->Void)->Void):Receiver<T>{
    return feed(
      (cb) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  static public function feed<T>(cb:(T->Void)->Automation):Receiver<T>{
    return Recall.Anon(
      (_:Noise,cont:T->Void) -> {
        return cb(cont);
      }
    );
  }
  static public function pure<T>(t:T):Receiver<T>{
    return into((cb) -> cb(t));
  }
  static public function fromFuture<T>(ft:Future<T>):Receiver<T>{
    return feed(
      (cb) -> {
        var canceller = ft.handle(cb);
        return Task.Anon(null,canceller.cancel).toAutomation();
      }
    );
  }
  static public function fromThunk<T>(thk:Thunk<T>):Receiver<T>{
    return into((cb) -> cb(thk()));
  }
  static public function fromReactor<T>(rct:ReactorDef<T>):Receiver<T>{
    return into((cb) -> rct.upply(cb));
  }
}
class ReceiverLift{
  static public function toWaiter<T>(self:Receiver<T>):Waiter<T,Dynamic>{
    return Waiter.fromReceiver(self);
  }
  static public function map<T,TT>(self:Receiver<T>,fn:T->TT):Receiver<TT>{
    return Receiver.into(
      (cb) -> self.apply(
        (t) -> cb(fn(t))  
      )
    );
  }
  static public function flat_map<T,TT>(self:Receiver<T>,fn:T->Receiver<TT>):Receiver<TT>{
    return Receiver.into(
      (cbTT:TT->Void) -> Automation.interim(
        Reactor.into(
          (cbA:AutomationDef->Void) -> {
            var auto_trigger  = Future.trigger();
            var value_trigger = Future.trigger();

            var auto_future   = auto_trigger.asFuture();
            var value_future  = value_trigger.asFuture();

                auto_future.flatMap(
                  (auto) -> value_future.map(__.couple.bind(auto))
                ).map(
                  __.decouple((auto,value) -> fn(value).apply(cbTT))
                ).handle(
                  (auto1) -> cbA(auto1)
                );

            var auto = self.apply(
              (t:T) -> value_trigger.trigger(t)
            );
            auto_trigger.trigger(auto);
          }
        )
      )
    );
  }
  static public function apply<T>(self:Receiver<T>,cb:T->Void):Automation{
    return self.applyII(Noise,cb);
  }
  static public function toUIO<T>(self:Receiver<T>):UIODef<T>{
    return Recall.Anon(
      (auto:Automation,cb:T->Void) -> auto.snoc(self.apply(cb))
    );
  }
}