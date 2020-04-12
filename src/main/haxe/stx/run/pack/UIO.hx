package stx.run.pack;

@:using(stx.run.pack.UIO.UIOLift)
@:forward abstract UIO<T>(UIODef<T>) from UIODef<T> to UIODef<T>{
  static public var _(default,never) = UIOLift;
  
  static public function feed<T>(handler:(T->Void)->Automation):UIO<T>{
    return Recall.Anon((auto:Automation,cb:T->Void) -> auto.snoc(Task.Anon(handler.bind(cb))));
  }
  static public function into<T>(handler:(T->Void)->Void):UIO<T>{
    return feed(
      (cb) -> { handler(cb); return Automation.unit(); }
    );
  }
  static public function fromFuture<T>(v:Future<T>):UIO<T>{
    return Receiver.fromFuture(v).toUIO();
  }
  static public function fromThunk<T>(v:Thunk<T>):UIO<T>{
    return into((cb) -> cb(v()));
  }
  static public function fromReceiverDef<T>(fn:(T->Void)->Automation):UIO<T>{
    return feed((cb) -> fn(cb));
  }

  @:to public function toIO():IO<T,Dynamic>{
    return IO.fromUIODef(this);
  }

  // static public function attempt<T,TT,E>(self:UIODef<T>,fn:T->Res<TT,E>):IODef<TT,E>{
  //   return Recall.Anon(
  //     (auto,cb) -> self.applyII(
  //       auto,
  //       (r) -> cb(fn(r))
  //     )
  //   );
  // }
  public function attempt<TT,E>(fn:T->Res<TT,E>):IO<TT,E>{
    return Recall.Anon(
      (auto,cb) -> this.applyII(
        auto,
        (r) -> cb(fn(r))
      )
    );
  }
}

class UIOLift extends Clazz{
  static public function map<T,TT>(self:UIO<T>,fn:T->TT):UIO<TT>{
    return Recall.Anon((auto:Automation,cb:TT->Void) -> self.applyII(auto,(t) -> cb(fn(t))));
  }
  static public function command<T>(self:UIO<T>,cb:T->Void):UIO<T>{
    return map(self,__.command(cb));
  }
  static public function flat_map<T,TT,E>(self:UIO<T>,fn:T->UIO<TT>):UIO<TT>{
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
                (auto0:Automation) -> future_value.map(__.couple.bind(auto0))
              ).map(
                __.decouple(
                  (auto0:Automation,t) -> fn(t).applyII(auto0,cbTT)
                )
              ).handle(
                (auto1:Automation) -> cbA(auto1)
              );

          var auto0 = self.applyII(auto,
            (t:T) -> trigger_value.trigger(t)
          );
          trigger_auto.trigger(auto0);
        })
      );}
    );
  }
}