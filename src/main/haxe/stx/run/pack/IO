package stx.run.pack;

@:using(stx.run.pack.IO.IOLift)
@:forward abstract IO<O,E>(IODef<O,E>) from IODef<O,E> to IODef<O,E>{
  public function new(self) this = self;
  static public function lift<O,E>(self:IODef<O,E>):IO<O,E>{
    return new IO(self);
  }
  static public inline function pure<O>(v:O):IO<O,Noise>{
    return fromFunXR(() -> v);
  }
  static public function feed<O,E>(handler:(Res<O,E>->Void)->Automation):IO<O,E>{
    return Recall.Anon(
      (auto:Automation,cont:Res<O,E>->Void) -> {
        return auto.snoc(Task.Anon(handler.bind(cont)));
      }
    );
  }
  static public function call<O,E>(handler:(Res<O,E>->Void)->Void):IO<O,E>{
    return feed( 
      (cb:Res<O,E>->Void) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  static public inline function fromUIODef<T>(fn:Recall<Automation,T,Automation>):IO<T,Dynamic>{
    return Recall.Anon(
      (auto:Automation,cb:Res<T,Dynamic>->Void) -> fn.applyII(auto,
        (t:T) -> cb(__.success(t))
      )
    );
  }
  static public inline function fromIODef<O,E>(fn:Automation->(Res<O,E>->Void)->Automation):IO<O,E>{
    return Recall.Anon(
      (auto,cb) -> fn(auto,cb)
    );
  }
  @:from static public inline function fromFunXRes<R,E>(chk:Void -> Res<R,E>):IO<R,E>{
    return call((handler) -> handler(chk()));
  }
  static public inline function fromRes<R,E>(chk:Res<R,E>):IO<R,E>{
    return fromFunXRes(()->chk);
  }

  static public inline function fromFunXR<R>(thk:Void -> R):IO<R,Noise>{
    return fromFunXRes(
      () -> __.success(thk())
    );
  }
  static public inline function fromFun1R<R,E>(fn:Noise -> Res<R,E>):IO<R,E>{
    return fromFunXRes(fn.bind(Noise));
  }
  static public inline function fromFunXIO<R,E>(fn:Unary<Noise,IO<R,E>>):IO<R,E>{
    return feed((handler) -> fn(Noise).applyII(Automation.unit(),handler));
  }
  static public inline function bind_fold<A,E,R>(fn:A->R->IO<R,E>,arr:Array<A>,r:R):IO<R,E>{
    return arr.lfold(
      (next,memo:IODef<R,E>) -> return memo.flat_map((r:R) -> fn(next,r)),
      fromRes(__.success(r))
    );
  }
  public function prj():IODef<O,E>{
    return this;
  }
}
class IOLift{
  // static public function feed<O,E>(fn:(Res<O,E>->Automation->Void)->Automation):IO<O,E>{
  //   return lift(
  //     (auto:Automation,cont:Res<O,E>->Void) -> cont(fn.bind(_,auto))
  //   );
  // }
  static public function map<O,Oi,E>(self:IO<O,E>,fn:O->Oi):IO<Oi,E>{
    return Recall.Anon(
      (auto:Automation,cont:Res<Oi,E>->Void) -> self.applyII(auto,
        (oc:Res<O,E>) -> cont(oc.map(fn))
      )
    );
  }
  // static public function flat_map<O,Oi,E>(fn:O->IO<Oi,E>,self:IO<O,E>):IO<Oi,E>{
  //   return IO.lift((auto) -> 
  //     WaiteO.lift((cb:Res<Oi,E>->Void)
  //       -> self(auto)(
  //         (chk) -> chk.fold(
  //           (v) -> fn(v)(auto)(cb),
  //           (e) -> {cb(Left(e));return Automation.unit();}
  //         )
  //       )
  //     )
  //   );
  // }
  static public function fold<O,Oi,E>(self:IO<O,E>,v:O->Oi,e:Null<Err<E>>->Oi):UIO<Oi>{
    return Recall.Anon(
      (auto,cb) -> self.applyII(auto,(chk) -> cb(chk.fold(v,e)))
    );
  }
  static public function zip<O,O1,E>(self:IO<O,E>,that:IO<O1,E>):IO<Couple<O,O1>,E>{
    return flat_map(
      self,
      (r:O) -> that.map(
        (rr:O1) -> (__.couple(r,rr):Couple<O,O1>)
      )
    );
  }
  static public function flat_map<T,TT,E>(self:IO<T,E>,fn:T->IO<TT,E>):IO<TT,E>{
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
  // static public function export<I,O,E,O>(fn:O-OiChannel<I,O,E>,self:IO<O,E>):Channel<I,O,E>{
  //   return Channel.lift(
  //     __.arw().cont()(O  //       (chunk:Res<I,E>,contN:Strand<Res<O,E>>) ->
  //         return Automation.inj.interim(
  //           Receiver.lift((cont1:Automation -> Void) -> self(Automation.unit())(
  //               (r_data:Res<O,E>) -> r_data.fold(
  //                 (v) -> cont1(fn(v).prepare(chunk,contN)),
  //                 (e) -> cont1(contN(Left(e),Automation.unit()))
  //               )
  //             )
  //           )
  //         )
  //     )
  //   );
  // }
  static public function errata<O,E,EE>(self:IO<O,E>,fn:Err<E>->Err<EE>):IO<O,EE>{
    return IO.lift(UIO._.map(
      self.prj(),
      (either:Res<O,E>) -> either.errata(fn)
    ));
  }
  static public function wait<O,E>(self:IO<O,E>,?auto:Automation):WaiterDef<O,E>{
    auto = __.option(auto).def(Automation.unit);
    return Recall.Anon(
      (_:Noise,cont:Res<O,E>->Void) -> self.applyII(auto,cont)
    );
  }
  static public function elide<O,E>(self:IO<O,E>):IO<Any,E>{
    return map(
      self,
      (v:O) -> (v:Any)
    );
  }
  static public function point<O,E>(self:IO<O,E>,fn:O->EIO<E>):EIO<E>{
    return EIO.lift(flat_map(
      self,
      fn.fn().then(_ -> _.toIO())
    ).fold(
      (_) -> new Report(None),
      (e) -> new Report(Some(e))
    ));
  }
}