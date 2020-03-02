package stx.run;

class Lift{
  static public function run(__:Wildcard):Module{
    return new stx.run.Module();
  }
}
class LiftThunkToUIO{
  static public function toUIO<T>(fn:Void->T):UIODef<T>{
    return UIO.inj().fromThunk(fn);
  }
}
typedef LiftReactorDef  = stx.run.pack.reactor.Implementation;
typedef LiftReceiverDef = stx.run.pack.receiver.Implementation;
typedef LiftWaiterDef   = stx.run.pack.waiter.Implementation;
typedef LiftEIODef      = stx.run.pack.eio.Implementation;
typedef LiftUIODef      = stx.run.pack.uio.Implementation;
typedef LiftIODef       = stx.run.pack.io.Implementation;
