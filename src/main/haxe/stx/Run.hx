package stx;

class Pack{
  
}
typedef Recall<I,O,R>         = stx.run.pack.Recall<I,O,R>;
typedef RecallDef<I,O,R>  = {
  public function applyII(i:I,cb:Sink<O>):R;
  public function asRecallDef():RecallDef<I,O,R>;
}
interface RecallApi<I,O,R> extends App2R<I,Sink<O>,R>{
  public function asRecallDef():RecallDef<I,O,R>;
}
typedef RecallFun<I,O,R>      = (i:I,cb:Sink<O>) ->R;

enum TaskOpSum{
  Pursue;
  Escape(?pos:Pos);
}
typedef TaskOp                    = TaskOpSum;


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

//typedef ReactorDef<T>         = RecallDef<Noise,T,Void>;
//typedef Reactor<T>            = stx.run.pack.Reactor<T>;

//typedef ReceiverDef<T>        = RecallDef<Noise,T,Automation>;
//typedef Receiver<O>           = stx.run.pack.Receiver<O>;

//typedef WaiterDef<T,E>        = RecallDef<Noise,Res<T,E>,Automation>;
//typedef Waiter<R,E>           = stx.run.pack.Waiter<R,E>;

//typedef IODef<T,E>            = RecallDef<Automation,Res<T,E>,Automation>;
//typedef IO<T,E>               = stx.run.pack.IO<T,E>;

//typedef UIODef<T>             = RecallDef<Automation,T,Automation>;
//typedef UIO<T>                = stx.run.pack.UIO<T>;

//typedef EIODef<E>             = RecallDef<Automation,Report<E>,Automation>;
//typedef EIO<E>                = stx.run.pack.EIO<E>;

//typedef AutomationDef         = stx.run.pack.Automation.AutomationDef;
//typedef Automation            = stx.run.pack.Automation;

typedef AutomationError       = stx.run.pack.AutomationError;
typedef AutomationFailure<E>  = stx.run.pack.AutomationFailure<E>;

typedef TaskApi               = stx.run.pack.Task.TaskApi;
typedef Task                  = stx.run.pack.Task;



typedef Profile               = stx.run.pack.Profile;
//typedef Spinner               = stx.run.pack.Spinner;

typedef Progress              = stx.run.pack.Progress;
typedef ProgressSum           = stx.run.pack.Progress.ProgressSum;

typedef Progression           = stx.run.pack.Progression;


//typedef LiftRecallDef         = stx.run.pack.Recall.RecallLift;
//typedef LiftReactorDef        = stx.run.pack.Reactor.ReactorLift;
//typedef LiftReceiverDef       = stx.run.pack.Receiver.ReceiverLift;
//typedef LiftWaiterDef         = stx.run.pack.Waiter.WaiterLift;
//typedef LiftEIODef            = stx.run.pack.EIO.EIOLift;
//typedef LiftUIODef            = stx.run.pack.UIO.UIOLift;
//typedef LiftIODef             = stx.run.pack.IO.IOLift;

class LiftRun{
  static public function run(__:Wildcard):Module{
    return new stx.run.pack.Module();
  }
  static public function timer(__:Wildcard){
    return Timer.unit();
  }
  static public function toVoid<I,O>(rc:RecallDef<I,O,Noise>):RecallDef<I,O,Void>{
    return Recall.Anon(
      function (i:I,cont:Sink<O>):Void {
        rc.applyII(i,cont);
      }
    );
  }
}
//typedef LiftThunkToUIO        = stx.run.lift.LiftThunkToUIO;
//typedef LiftIO                = stx.run.lift.LiftIO;

typedef Module                = stx.run.pack.Module;

typedef Next                  = stx.run.pack.Next;
typedef NextSum               = stx.run.pack.Next.NextSum;

typedef ScheduleApi           = stx.run.pack.Schedule.ScheduleApi;
typedef Schedule              = stx.run.pack.Schedule;

typedef SchedulerApi          = stx.run.pack.Scheduler.SchedulerApi;
typedef Scheduler             = stx.run.pack.Scheduler;



interface ActApi{
  public function upply(thunk:Void->Void):Void; 
  public function reply():Future<Noise>;

  public function report(err:Err<Dynamic>):Void;

  public function asActApi():ActApi;
}
typedef Act                   = stx.run.pack.Act;
typedef Timer                 = stx.run.pack.Timer;

typedef Seconds               = stx.run.pack.Seconds;
typedef MilliSeconds          = stx.run.pack.MilliSeconds;
typedef Runtime               = stx.run.pack.Runtime;
typedef Processor             = stx.run.pack.Processor;
typedef Tick                  = stx.run.pack.processor.Tick;