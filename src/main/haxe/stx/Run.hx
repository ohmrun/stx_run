package stx;

class Pack{
  
}
typedef LimitDef = {
  @:optional var unchanged : Int;//how many times can the progression be unchanged before bailing out.

  @:optional var duration  : MilliSeconds;//milliseconds how long can this process take in total ''.
  @:optional var hanging   : MilliSeconds;//milliseconds how long can the progression be unchanged ''.
}
typedef Limit                 = LimitDef;

//typedef BangDef               = RecallDef<Noise,Noise,Void>;
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
typedef RunError              = stx.run.pack.RunError;
typedef RunFailure<E>         = stx.run.pack.RunFailure<E>;

typedef TaskApi               = stx.run.pack.Task.TaskApi;
typedef Task                  = stx.run.pack.Task;

//typedef Profile               = stx.run.pack.Profile;
//typedef Spinner               = stx.run.pack.Spinner;

typedef Progress              = stx.run.pack.Progress;
typedef ProgressSum           = stx.run.pack.Progress.ProgressSum;

typedef Progression           = stx.run.pack.Progression;


class LiftRun{
  static public function run(__:Wildcard):Module{
    return new stx.run.pack.Module();
  }
  static public function timer(__:Wildcard){
    return Timer.unit();
  }
}

typedef Module                = stx.run.pack.Module;

typedef ScheduleDef           = stx.run.pack.Schedule.ScheduleDef;
typedef Schedule              = stx.run.pack.Schedule;

typedef SchedulerApi          = stx.run.pack.Scheduler.SchedulerApi;
typedef Scheduler             = stx.run.pack.Scheduler;

typedef ActApi                = stx.run.pack.Act.ActApi;
typedef Act                   = stx.run.pack.Act;
typedef Timer                 = stx.run.pack.Timer;
typedef Seconds               = stx.run.pack.Seconds;
typedef MilliSeconds          = stx.run.pack.MilliSeconds;
typedef Runtime               = stx.run.pack.Runtime;
typedef Tick                  = stx.run.pack.processor.Tick;
typedef Stat                  = stx.run.pack.Stat;
typedef Clock                 = stx.run.pack.Clock;
typedef JobDef<R,E>           = stx.run.pack.Job.JobDef<R,E>;
typedef Job<R,E>              = stx.run.pack.Job<R,E>;
typedef Agenda<E>             = stx.run.pack.Agenda<E>;
