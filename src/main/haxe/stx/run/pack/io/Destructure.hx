package stx.run.pack.io;


class Destructure extends Clazz{
  // public function feed<R,E>(fn:(Outcome<R,E>->Automation->Void)->Automation):IO<R,E>{
  //   return lift(
  //     (auto:Automation,cont:Outcome<R,E>->Void) -> cont(fn.bind(_,auto))
  //   );
  // }
  public function map<R,Z,E>(fn:R->Z,self:IODef<R,E>):IODef<Z,E>{
    return Recall.Anon(
      (auto:Automation,cont:Outcome<Z,E>->Void) -> self.duoply(auto,
        (oc:Outcome<R,E>) -> cont(oc.map(fn))
      )
    );
  }
  // public function fmap<R,Z,E>(fn:R->IO<Z,E>,thiz:IO<R,E>):IO<Z,E>{
  //   return IO.lift((auto) -> 
  //     Waiter.lift((cb:Outcome<Z,E>->Void)
  //       -> thiz(auto)(
  //         (chk) -> chk.fold(
  //           (v) -> fn(v)(auto)(cb),
  //           (e) -> {cb(Left(e));return Automation.unit();}
  //         )
  //       )
  //     )
  //   );
  // }
  public function fold<R,Z,E>(v:R->Z,e:Null<TypedError<E>>->Z,thiz:IODef<R,E>):UIODef<Z>{
    return Recall.Anon(
      (auto,cb) -> thiz.duoply(auto,(chk) -> cb(chk.fold(v,e)))
    );
  }
  public function zip<R,R1,E>(that:IODef<R1,E>,thiz:IODef<R,E>):IODef<Tuple2<R,R1>,E>{
    return fmap(
      (r:R) -> that.map(
        (rr:R1) -> (tuple2(r,rr):Tuple2<R,R1>)
        ),
      thiz
    );
  }
  public function fmap<T,TT,E>(fn:T->IODef<TT,E>,self:IODef<T,E>):IODef<TT,E>{
    return Recall.Anon(
      function (auto:Automation,cbTT:Outcome<TT,E>->Void):Automation { return Automation.interim(
        Reactor.into((cbA:AutomationDef->Void) -> {
          var trigger_auto      = Future.trigger();
          var trigger_outcome   = Future.trigger();
          var future_auto       = trigger_auto.asFuture();
          var future_outcome    = trigger_outcome.asFuture();

          var error             = (e:Dynamic) -> Automation.failure(__.fault().of(E_UnknownAutomation(e)));

              future_auto.flatMap(
                (auto0:Automation) -> future_outcome.map(tuple2.bind(auto0))
              ).map(__.into2((auto0:Automation,oc:Outcome<T,E>) -> oc.fold((t) -> fn(t).duoply(auto0,cbTT),error))
              ).handle((auto1:Automation) -> cbA(auto1));

          var auto0 = self.duoply(auto,(oc:Outcome<T,E>) -> trigger_outcome.trigger(oc));
          trigger_auto.trigger(auto0);
        })
      );}
    );
  }
  // public function export<I,O,E,R>(fn:R->Channel<I,O,E>,self:IO<R,E>):Channel<I,O,E>{
  //   return Channel.lift(
  //     __.arw().cont()(
  //       (chunk:Outcome<I,E>,contN:Strand<Outcome<O,E>>) ->
  //         return Automation.inj.interim(
  //           Receiver.lift((cont1:Automation -> Void) -> self(Automation.unit())(
  //               (r_data:Outcome<R,E>) -> r_data.fold(
  //                 (v) -> cont1(fn(v).prepare(chunk,contN)),
  //                 (e) -> cont1(contN(Left(e),Automation.unit()))
  //               )
  //             )
  //           )
  //         )
  //     )
  //   );
  // }
  public function errata<T,E,EE>(fn:TypedError<E>->TypedError<EE>,self:IODef<T,E>):IODef<T,EE>{
    return __._(UIO._).map(
      (either:Outcome<T,E>) -> either.errata(fn),
      self
    );
  }
  public function wait<T,E>(?auto:Automation,self:IODef<T,E>):WaiterDef<T,E>{
    auto = __.option(auto).def(Automation.unit);
    return Recall.Anon(
      (_:Noise,cont:Outcome<T,E>->Void) -> self.duoply(auto,cont)
    );
  }
  public function point<T,E>(fn:T->EIODef<E>,self:IODef<T,E>):EIODef<E>{
    return fmap(
      fn.fn().then(_ -> _.toIO()),
      self
    ).fold(
      (_) -> new Report(None),
      (e) -> new Report(Some(e))
    );
  }
  public function elide<T,E>(self:IODef<T,E>):IODef<Any,E>{
    return map(
      (v:T) -> (v:Any),
      self
    );
  }
}