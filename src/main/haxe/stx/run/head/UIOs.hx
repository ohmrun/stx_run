package stx.run.head;

import stx.run.head.data.UIO in UIOT;

class UIOs{
  static public function lift<T>(uio:UIOT<T>):UIO<T>{
    return new UIO(uio);
  }
  @:noUsing static public function fromFuture<T>(v:Future<T>):UIO<T>{
    return UIO.lift(
      (auto) -> Receiver.lift(Receiver.fromFuture(v))//TODO
    );
  }
  @:noUsing static public function fromThunk<T>(v:Thunk<T>):UIO<T>{
    return UIO.lift(
      (auto) -> Receivers.fromThunk(v)
    );
  }
}