package stx.run;

class Pack{
  
}
typedef Recall<I,O,R>         = stx.run.pack.Recall<I,O,R>;
typedef RecallDef<I,O,R>      = stx.run.type.RecallDef<I,O,R>;
typedef RecallApi<I,O,R>      = stx.run.type.RecallApi<I,O,R>;
typedef RecallFun<I,O,R>      = (i:I,cb:Sink<O>) ->R;

typedef Op                    = stx.run.type.OpSum;

typedef LimitDef              = stx.run.type.LimitDef;

typedef BangDef               = RecallDef<Noise,Noise,Void>;
typedef Bang                  = stx.run.pack.Bang;

typedef ReactorDef<T>         = RecallDef<Noise,T,Void>;
typedef Reactor<T>            = stx.run.pack.Reactor<T>;

typedef ReceiverDef<T>        = RecallDef<Noise,T,Automation>;
typedef Receiver<O>           = stx.run.pack.Receiver<O>;

typedef WaiterDef<T,E>        = RecallDef<Noise,Res<T,E>,Automation>;
typedef Waiter<R,E>           = stx.run.pack.Waiter<R,E>;

typedef IODef<T,E>            = RecallDef<Automation,Res<T,E>,Automation>;
typedef IO<T,E>               = stx.run.pack.IO<T,E>;

typedef UIODef<T>             = RecallDef<Automation,T,Automation>;
typedef UIO<T>                = stx.run.pack.UIO<T>;

typedef EIODef<E>             = RecallDef<Automation,Report<E>,Automation>;
typedef EIO<E>                = stx.run.pack.EIO<E>;

typedef AutomationDef         = Task;
typedef Automation            = stx.run.pack.Automation;

typedef AutomationError       = stx.run.pack.AutomationError;
typedef AutomationFailure<E>  = stx.run.pack.AutomationFailure<E>;

typedef TaskApi               = stx.run.type.TaskApi;
typedef Task                  = stx.run.pack.Task;


typedef Limit                 = LimitDef;
typedef Profile               = stx.run.pack.Profile;
//typedef Spinner               = stx.run.pack.Spinner;

typedef ProgressSum           = stx.run.type.ProgressSum;
typedef Progression           = stx.run.pack.Progression;


typedef LiftRecallDef         = stx.run.pack.recall.Implementation;
typedef LiftReactorDef        = stx.run.pack.reactor.Implementation;
typedef LiftReceiverDef       = stx.run.pack.receiver.Implementation;
typedef LiftWaiterDef         = stx.run.pack.waiter.Implementation;
typedef LiftEIODef            = stx.run.pack.eio.Implementation;
typedef LiftUIODef            = stx.run.pack.uio.Implementation;
typedef LiftIODef             = stx.run.pack.io.Implementation;

typedef Lift                  = stx.run.pack.Lift;
typedef LiftThunkToUIO        = stx.run.lift.LiftThunkToUIO;
typedef LiftIO                = stx.run.lift.LiftIO;

typedef Module                = stx.run.pack.Module;

typedef TickSum               = stx.run.type.TickSum;
typedef Tick                  = TickSum;

interface ScheduleApi{
  public function reply():Tick;
  public function asScheduleApi():ScheduleApi;
}
typedef Schedule              = stx.run.pack.Schedule;

typedef Run                   = stx.run.pack.Run;
interface RunApi{
  public function upply(schedule:Schedule):Void; 
  public function apply(schedule:Schedule):Bang;
  
  public function report(err:Err<Dynamic>):Void;

  public function asRunApi():RunApi;
}

interface ActApi{
  public function upply(thunk:Void->Void):Void; 
  public function apply(thunk:Void->Void):Bang;

  public function report(err:Err<Dynamic>):Void;

  public function asActApi():ActApi;
}
typedef Act                   = stx.run.pack.Act;