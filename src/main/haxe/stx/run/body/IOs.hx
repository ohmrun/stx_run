package stx.run.body;

class IOs extends Clazz{
  public function map<R,Z,E>(fn:R->Z,thiz:IO<R,E>):IO<Z,E>{
    return IO.lift(thiz.prj().then(
      (chk) -> Waiter.lift(chk).map(fn).prj()
    ));
  }
  public function fmap<R,Z,E>(fn:R->IO<Z,E>,thiz:IO<R,E>):IO<Z,E>{
    return IO.lift((auto) -> 
      (cb:Chunk<Z,E>->Void)
        -> thiz(auto)(
          (chk) -> chk.fold(
            (v) -> fn(v)(auto)(cb),
            (e) -> {cb(End(e));return Automation.unit();},
            ()  -> {cb(Tap);return Automation.unit();}
          )
        )
    );
  }
  public function fold<R,Z,E>(v:R->Z,e:Null<TypedError<E>>->Z,n:Thunk<Z>,thiz:IO<R,E>):UIO<Z>{
    return UIO.lift((auto) -> 
      (cb) -> thiz(auto)(
        (chk) -> cb(Chunks._.fold.bind(v,e,n.prj())(chk))
      ));
  }
  public function zip<R,Z,R1,E>(fn:R->R1->Z,that:IO<R1,E>,thiz:IO<R,E>):IO<Z,E>{
    return IO.lift((auto) -> Waiter.lift(thiz(auto)).fmap(
      (x) -> Waiter.lift(that(auto)).map(
          (y) -> fn(x,y)
        )
      ).prj()
    );
  }
}