package stx.run.pack;

typedef ScheduleItemDef = Couple<Stat,Task>;

@:forward abstract ScheduleItem(ScheduleItemDef) from ScheduleItemDef to ScheduleItemDef{
  static public function lift(self:ScheduleItemDef):ScheduleItem{
    return new ScheduleItem(self);
  }
  static public function pure(task:Task):ScheduleItem{
    return lift(__.couple(new Stat(new Clock()),task));
  }
  public function new(self) this = self;
  public function value(){
    return this.fst().value();
  }
  public function progress(){
    return this.snd().progress.data;
  }
  public function is_less_than(that:ScheduleItem):Bool{
    return switch([progress(),that.progress()]){
      case [Pending,Pending] : value() < that.value();
      default                : progress().is_less_than(that.progress());
    }
  }
  public function pursue(){
    this.fst().enter();
    this.snd().pursue();
    this.fst().leave();
  }
  public function escape(){
    this.snd().escape();
  }
}
interface ProcessorApi{
  public function add(task:Task):Void;
  public function run(?thread:ThreadDef):Void;
  public function is_defined():Bool;
}
@:forward abstract Processor(ProcessorApi) from ProcessorApi{
  static public var ZERO : Processor = unit();
  static public function unit(){
    return new BaseProcesser();
  }
}
/**
  * Pops a ScheduleItem from the Array, which is ordered on `put`.
  * `pursue()`, and if it isn't finished; `put` the ScheduleItem back.
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
class BaseProcesser implements ProcessorApi{
  var clock   : Clock;
  var tasks   : Array<ScheduleItem>;

  public function new(){
    this.clock = new Clock();
    this.tasks = [];
  }
  public function add(task:Task){
    put(__.couple(new Stat(clock),task));
  }
  private function put(item:ScheduleItem){
    this.tasks.push(item);
    ArraySort.sort(this.tasks,eq);
  }
  private function eq(lhs:ScheduleItem,rhs:ScheduleItem):Int{
    return lhs.is_less_than(rhs) ? 1 : -1;
  }
  private function pop():ScheduleItem{
    return tasks.shift();
  }
  public function peek():ScheduleItem{
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
  public function run(?thread:ThreadDef):Void{
    thread = __.option(thread).defv(new ThreadApiBase());
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
    trace(peek().progress());
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
        Tick.Busy((cb) -> ft.handle((_) -> cb()));
      case Working | Secured | Escaped :
        Tick.Poll(); 
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
typedef ThreadDef = {
  public function enter(fn:Report<Dynamic>->Tick):Void;
}
class ThreadApiBase{
  public function new(){}
  public function enter(fn:Report<Dynamic>->Tick){
    //trace('enter');
    var inner: Bool -> Void = null;
        inner = (waiting:Bool) -> {
          var event : MainEvent = null;
              event = MainLoop.add(
                () -> {
                  //trace('running');
                  if(!waiting){
                    var status = fn(Report.unit());
                    switch(status){
                      case Tick.Busy(wake): 
                        waiting = true;
                        wake(inner.bind(false));
                        //BackOff?
                      case Tick.Poll(milliseconds) : 
                        event.delay(milliseconds == null ? null : (@:privateAccess milliseconds.toSeconds().prj()));
                      case Tick.Fail(e):
                        fn(Report.pure(e));
                      case Tick.Exit:
                        event.stop();
                    }
                  }
                }
          );
    }
    inner(false);
  }
}