package stx.run;

import stx.run.pack.uio.Typedef in UIOT;

class Lift{
  static public function run(__:Wildcard):Module{
    return new stx.run.Module();
  }
}
class LiftEIOType{
  static public function toEIO<E>(io:UIOT<Report<E>>){
    return EIO.lift(io);
  }
}
class LiftEIOUIO{
  static public function toEIO<E>(io:UIO<Report<E>>){
    return EIO.lift(io.prj());
  }
}
class LiftThunkToUIO{
  static public function toUIO<T>(fn:Void->T):UIO<T>{
    return UIO.inj.fromThunk(fn);
  }
}