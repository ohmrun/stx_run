package stx.run.pack.uio;

class Destructure extends Clazz{
  public function map<T,TT>(fn:T->TT,self:UIODef<T>):UIODef<TT>{
    return Recall.Anon((auto:Automation,cb:TT->Void) -> self.duoply(auto,(t) -> cb(fn(t))));
  }
  public function attempt<R,Z,E>(fn:R->Outcome<Z,E>,self:UIODef<R>):IODef<Z,E>{
    return Recall.Anon(
      (auto,cb) -> self.duoply(
        auto,
        (r) -> cb(fn(r))
      )
    );
  }
  public function command<T>(cb:T->Void,self:UIODef<T>):UIODef<T>{
    return map(__.command(cb),self);
  }
  public function fmap<T,TT,E>(fn:T->UIODef<TT>,self:UIODef<T>):UIODef<TT>{
    return Recall.Anon(
      function(auto:Automation,cbTT:TT->Void):Automation { return Automation.interim(
        Reactor.into((cbA:AutomationDef->Void) -> {
          var trigger_auto                 
                     = Future.trigger();
          var trigger_value                           = Future.trigger();
          var future_auto : Future<Automation>        = trigger_auto.asFuture();
          var future_value                            = trigger_value.asFuture();
          var error                                   = (e) -> Automation.failure(__.fault().of(E_UnknownAutomation(e)));

              future_auto.flatMap(
                (auto0:Automation) -> future_value.map(tuple2.bind(auto0))
              ).map(
                __.into2(
                  (auto0:Automation,t) -> fn(t).duoply(auto0,cbTT)
                )
              ).handle(
                (auto1:Automation) -> cbA(auto1)
              );

          var auto0 = self.duoply(auto,
            (t:T) -> trigger_value.trigger(t)
          );
          trigger_auto.trigger(auto0);
        })
      );}
    );
  }
}