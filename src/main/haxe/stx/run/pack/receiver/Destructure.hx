package stx.run.pack.receiver;

import stx.run.type.Package.Automation in AutomationT;

class Destructure extends Clazz{
  public function toWaiter<T>(self:ReceiverDef<T>):WaiterDef<T,Dynamic>{
    return Waiter.inj().fromReceiver(self);
  }

  public function map<T,TT>(fn:T->TT,self:ReceiverDef<T>):ReceiverDef<TT>{
    return Receiver.inj().into(
      (cb) -> self.apply(
        (t) -> cb(fn(t))  
      )
    );
  }
  public function fmap<T,TT>(fn:T->ReceiverDef<TT>,self:ReceiverDef<T>):ReceiverDef<TT>{
    return Receiver.inj().into(
      (cbTT:TT->Void) -> Interim(
        Reactor.inj().into(
          (cbA:AutomationT->Void) -> {
            var auto_trigger  = Future.trigger();
            var value_trigger = Future.trigger();

            var auto_future   = auto_trigger.asFuture();
            var value_future  = value_trigger.asFuture();

                auto_future.flatMap(
                  (auto) -> value_future.map(tuple2.bind(auto))
                ).map(
                  __.into2((auto,value) -> fn(value).apply(cbTT))
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
  public function apply<T>(cb:T->Void,self:ReceiverDef<T>):Automation{
    return self.duoply(Noise,cb);
  }
  public function toUIO<T>(self:ReceiverDef<T>):UIODef<T>{
    return Recall.anon(
      (auto:Automation,cb:T->Void) -> auto.concat(self.apply(cb))
    );
  }
}