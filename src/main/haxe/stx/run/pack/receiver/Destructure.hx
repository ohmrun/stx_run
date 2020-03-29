package stx.run.pack.receiver;

class Destructure extends Clazz{
  public function toWaiter<T>(self:Receiver<T>):Waiter<T,Dynamic>{
    return Waiter.fromReceiver(self);
  }

  public function map<T,TT>(fn:T->TT,self:Receiver<T>):Receiver<TT>{
    return Receiver.into(
      (cb) -> self.apply(
        (t) -> cb(fn(t))  
      )
    );
  }
  public function fmap<T,TT>(fn:T->Receiver<TT>,self:Receiver<T>):Receiver<TT>{
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
  public function apply<T>(cb:T->Void,self:Receiver<T>):Automation{
    return self.applyII(Noise,cb);
  }
  public function toUIO<T>(self:Receiver<T>):UIODef<T>{
    return Recall.Anon(
      (auto:Automation,cb:T->Void) -> auto.snoc(self.apply(cb))
    );
  }
}