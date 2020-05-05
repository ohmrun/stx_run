package stx;

class Pack{
  
}
typedef LimitDef = {
  @:optional var unchanged : Int;//how many times can the progression be unchanged before bailing out.

  @:optional var duration  : MilliSeconds;//milliseconds how long can this process take in total ''.
  @:optional var hanging   : MilliSeconds;//milliseconds how long can the progression be unchanged ''.
}
typedef Limit                 = LimitDef;


abstract Bang(Future<Noise>) from Future<Noise> to Future<Noise>{
  static public function pure(fn:Void->Void){
    return Future.async(
      (cb) -> {
        fn();
        cb(Noise);
      }
    );
  }
}
class LiftRun{

  static public function timer(__:Wildcard){
    return Timer.unit();
  }
}

typedef Act                   = stx.run.pack.Act;
typedef ActApi                = stx.run.pack.Act.ActApi;

typedef RunError              = stx.run.pack.RunError;
typedef RunFailure<E>         = stx.run.pack.RunFailure<E>;

typedef Timer                 = stx.run.pack.Timer;

typedef Seconds               = stx.run.pack.Seconds;
typedef MilliSeconds          = stx.run.pack.MilliSeconds;

typedef Stat                  = stx.run.pack.Stat;
typedef Clock                 = stx.run.pack.Clock;

typedef JobDef<R,E>           = stx.run.pack.Job.JobDef<R,E>;
typedef Job<R,E>              = stx.run.pack.Job<R,E>;
typedef Agenda<E>             = stx.run.pack.Agenda<E>;
