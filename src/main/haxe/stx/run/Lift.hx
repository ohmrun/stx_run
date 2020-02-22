package stx.run;

import stx.run.head.data.UIO in UIOT;


class Lift{
  static public function run(__:Wildcard):Module{
    return new stx.run.Module();
  }
  static public inline function observe<T>(v:Stx<T>):Observer<T>{
    return v.pull(run(__).observer());
  }
  static public inline function receive<T>(v:Stx<T>):Receiver<T>{
    return v.pull(run(__).observer()).toReceiver();
  }
  static public inline function wait<R,E>(v:Stx<Chunk<R,E>>):Waiter<R,E>{
    return v.pull(Waiter.fromChunk);
  }
}
class LiftEIOType{
  static public function toEIO<E>(io:UIOT<Option<TypedError<E>>>){
    return EIOs.lift(io);
  }
}
class LiftEIOUIO{
  static public function toEIO<E>(io:UIO<Option<TypedError<E>>>){
    return EIOs.lift(io);
  }
}