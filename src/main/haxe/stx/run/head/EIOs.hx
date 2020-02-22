package stx.run.head;

import stx.run.head.data.Receiver in ReceiverT;

class EIOs{
  static public var _(default,null) = new stx.run.body.EIOs();
  @:noUsing static public function lift<E>(f:Unary<Automation,ReceiverT<Option<TypedError<E>>>>):EIO<E>{
    return new EIO(f);
  }
  static public function unit<E>():EIO<E>{
    return lift( (auto) -> (next) -> {next(None);return auto;});
  }
  static public function pure<E>(err:TypedError<E>):EIO<E>{
    return lift( (auto) -> (next) -> {next(Some(err));return auto;});
  }
  static public function fromThunk<E>():Unary<Thunk<Option<TypedError<E>>>,EIO<E>>{
    return (thk) -> EIO.fromThunk(thk);
  } 
  static public function bfold<T,E>(fn:T->Option<TypedError<E>>->EIO<E>,arr:Array<T>):EIO<E>{
    return arr.lfold(
      (next:T,memo:EIO<E>) -> {
        return EIO.lift(
          memo.prj().bound(
            (auto:Automation,rec:Receiver<Option<TypedError<E>>>) -> {
              return Receiver.lift(rec).fmap(
                (opt) -> Receiver.lift(fn(next,opt)(auto))
              );
            }
          )
        );
      }, 
      lift((automation) -> (next) -> {
        next(None);
        return Automation.unit();
      })
    );
  }
}