package stx.run.lift;

class LiftThunkToUIO{
  static public function toUIO<T>(fn:Void->T):UIODef<T>{
    return UIO.fromThunk(fn);
  }
}