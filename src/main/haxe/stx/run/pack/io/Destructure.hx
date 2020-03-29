package stx.run.pack.io;


class Destructure extends Clazz{
  // public function feed<R,E>(fn:(Res<R,E>->Automation->Void)->Automation):IO<R,E>{
  //   return lift(
  //     (auto:Automation,cont:Res<R,E>->Void) -> cont(fn.bind(_,auto))
  //   );
  // }
  public function map<R,Z,E>(fn:R->Z,self:IO<R,E>):IO<Z,E>{
    return Recall.Anon(
      (auto:Automation,cont:Res<Z,E>->Void) -> self.applyII(auto,
        (oc:Res<R,E>) -> cont(oc.map(fn))
      )
    );
  }
  // public function fmap<R,Z,E>(fn:R->IO<Z,E>,thiz:IO<R,E>):IO<Z,E>{
  //   return IO.lift((auto) -> 
  //     Waiter.lift((cb:Res<Z,E>->Void)
  //       -> thiz(auto)(
  //         (chk) -> chk.fold(
  //           (v) -> fn(v)(auto)(cb),
  //           (e) -> {cb(Left(e));return Automation.unit();}
  //         )
  //       )
  //     )
  //   );
  // }
  public function fold<R,Z,E>(v:R->Z,e:Null<Err<E>>->Z,thiz:IO<R,E>):UIO<Z>{
    return Recall.Anon(
      (auto,cb) -> thiz.applyII(auto,(chk) -> cb(chk.fold(v,e)))
    );
  }
  public function zip<R,R1,E>(that:IO<R1,E>,thiz:IO<R,E>):IO<Couple<R,R1>,E>{
    return fmap(
      (r:R) -> that.map(
        (rr:R1) -> (__.couple(r,rr):Couple<R,R1>)
        ),
      thiz
    );
  }
  public function fmap<T,TT,E>(fn:T->IO<TT,E>,self:IO<T,E>):IO<TT,E>{
    return Recall.Anon(
      function (auto:Automation,cbTT:Res<TT,E>->Void):Automation { return Automation.interim(
        Reactor.into((cbA:AutomationDef->Void) -> {
          var trigger_auto      = Future.trigger();
          var trigger_outcome   = Future.trigger();
          var future_auto       = trigger_auto.asFuture();
          var future_outcome    = trigger_outcome.asFuture();

          var error             = (e:Dynamic) -> Automation.failure(__.fault().of(E_UnknownAutomation(e)));

              future_auto.flatMap(
                (auto0:Automation) -> future_outcome.map(__.couple.bind(auto0))
              ).map(__.decouple((auto0:Automation,oc:Res<T,E>) -> oc.fold((t) -> fn(t).applyII(auto0,cbTT),error))
              ).handle((auto1:Automation) -> cbA(auto1));

          var auto0 = self.applyII(auto,(oc:Res<T,E>) -> trigger_outcome.trigger(oc));
          trigger_auto.trigger(auto0);
        })
      );}
    );
  }
  // public function export<I,O,E,R>(fn:R->Channel<I,O,E>,self:IO<R,E>):Channel<I,O,E>{
  //   return Channel.lift(
  //     __.arw().cont()(
  //       (chunk:Res<I,E>,contN:Strand<Res<O,E>>) ->
  //         return Automation.inj.interim(
  //           Receiver.lift((cont1:Automation -> Void) -> self(Automation.unit())(
  //               (r_data:Res<R,E>) -> r_data.fold(
  //                 (v) -> cont1(fn(v).prepare(chunk,contN)),
  //                 (e) -> cont1(contN(Left(e),Automation.unit()))
  //               )
  //             )
  //           )
  //         )
  //     )
  //   );
  // }
  public function errata<T,E,EE>(fn:Err<E>->Err<EE>,self:IO<T,E>):IO<T,EE>{
    return __._(UIO._).map(
      (either:Res<T,E>) -> either.errata(fn),
      self
    );
  }
  public function wait<T,E>(?auto:Automation,self:IO<T,E>):WaiterDef<T,E>{
    auto = __.option(auto).def(Automation.unit);
    return Recall.Anon(
      (_:Noise,cont:Res<T,E>->Void) -> self.applyII(auto,cont)
    );
  }
  public function elide<T,E>(self:IO<T,E>):IO<Any,E>{
    return map(
      (v:T) -> (v:Any),
      self
    );
  }
  public function point<T,E>(fn:T->EIO<E>,self:IO<T,E>):EIO<E>{
    return EIO.lift(fmap(
      fn.fn().then(_ -> _.toIO()),
      self
    ).fold(
      (_) -> new Report(None),
      (e) -> new Report(Some(e))
    ));
  }
}