package stx.run.pack;


@:allow(stx.run) interface SchedulerApi{
  public          function put(schedule:Schedule):Void;

  public          function status():Next;
  
  private         function pursue():Void;
  private         function escape():Void;
  
  
  public          function asSchedulerApi():SchedulerApi;
}

@:forward abstract Scheduler(SchedulerApi) from SchedulerApi{
  static public var ZERO(default,never) = unit();

  private function new(fn) this = fn;

  static public function unit():Scheduler{
    return new stx.run.pack.scheduler.term.Base().asSchedulerApi();
  }
  static public function put(schedule:Schedule){
    ZERO.put(schedule);
  }
}