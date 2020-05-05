package stx.run.pack;

interface SchedulerApi{
  public function add(task:Task):Void;
  public function run(?thread:Runtime):Void;
  public function is_defined():Bool;
}
@:forward abstract Scheduler(SchedulerApi) from SchedulerApi{
  static public var ZERO : Scheduler = unit();
  static public function unit(){
    return new BaseScheduler();
  }
}
/**
  * Pops a Schedule from the Array, which is ordered on `put`.
  * `pursue()`, and if it isn't finished; `put` the Schedule back.
  * 
  * Ordering (`is_less_than`) is done by the `value()` of `Stat` where `Pending` 
  * (usually the least recent winds up at the left)
  * and by the `EnumIndex` of `Progress` otherwise. Problem, Pending....
  * 
  * Always '`pursues()` the `[0]` of `tasks`, so `Task`s stuck on `Pending` will fuck it atm.
  * There is a data on `Progression` which could be used to detect whether of
  * not a Task is setting a new progression, just I`m assuming that Tasks are well
  * behaved until the converse comes up.
**/
class BaseScheduler implements SchedulerApi{
  var clock   : Clock;
  var tasks   : Array<Schedule>;

  public function new(){
    this.clock = new Clock();
    this.tasks = [];
  }
  public function add(task:Task){
    put(__.couple(Stat.pure(clock),task));
  }
  private function put(item:Schedule){
    this.tasks.push(item);
    ArraySort.sort(this.tasks,eq);
  }
  private function eq(lhs:Schedule,rhs:Schedule):Int{
    return lhs.is_less_than(rhs) ? 1 : -1;
  }
  private function pop():Schedule{
    return tasks.shift();
  }
  public function peek():Schedule{
    return tasks[0];
  }
  public function is_defined(){
    return this.tasks.is_defined();
  }
  public function size(){
    return this.tasks.length;
  }
  private function escape(){
    for(schedule in tasks){
      schedule.escape();
    }
  }
  public function run(?thread:Runtime):Void{
    thread = __.option(thread).defv(new stx.run.pack.Runtime.RuntimeApiBase());
    thread.enter(serve);
  }
  private function serve(res:Report<Dynamic>):Tick{
    return switch(res){
      case Some(e)        : 
        error(e);
        Tick.Exit;
      case None  :
        is_defined().if_else(
          pursue,
          ()->Tick.Exit
        );
    }
  }
  private function pursue():Tick{
    //trace(peek().snd());
    return switch(peek().progress()){
      case Pending     : 
        var schedule = pop();
            schedule.pursue();
        if(schedule.progress().ongoing){
          put(schedule);
        }
        Tick.Poll();
      case Problem(e)  : 
        Tick.Fail(e);
      case Polling(p)  : 
        Tick.Poll(p);
      case Waiting(ft) :
        
        Tick.Busy(
          (cb) -> ft.handle(
            (_) -> {
              trace(peek().snd());
              cb();
            }
          )
        );
      case Working  :
        Tick.Poll(); 
      case Secured | Escaped :
        Tick.Exit;
    }
  }
  private function error(e){
    MainLoop.runInMainThread(
      () -> {
        throw(e);
      }
    );
  }
}
