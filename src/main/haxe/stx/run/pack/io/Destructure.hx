package stx.run.pack.io;

class Destructure extends Clazz{
  public function map<R,Z,E>(fn:R->Z,thiz:IO<R,E>):IO<Z,E>{
    return IO.lift(thiz.prj().then(
      (wtr) -> wtr.map(fn)
    ));
  }
  public function fmap<R,Z,E>(fn:R->IO<Z,E>,thiz:IO<R,E>):IO<Z,E>{
    return IO.lift((auto) -> 
      Waiter.lift((cb:Outcome<Z,E>->Void)
        -> thiz(auto)(
          (chk) -> chk.fold(
            (v) -> fn(v)(auto)(cb),
            (e) -> {cb(Left(e));return Automation.unit();}
          )
        )
      )
    );
  }
  public function fold<R,Z,E>(v:R->Z,e:Null<TypedError<E>>->Z,thiz:IO<R,E>):UIO<Z>{
    return UIO.lift((auto) -> 
      Receiver.lift((cb) -> thiz(auto)(
        (chk) -> cb(Outcome.inj._.fold.bind(v,e)(chk))
      ))
    );
  }
  public function zip<R,Z,R1,E>(fn:R->R1->Z,that:IO<R1,E>,thiz:IO<R,E>):IO<Z,E>{
    return thiz.fmap(
      (r) -> that.map(fn.bind(r))
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
}