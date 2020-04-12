package stx.run.pack;

typedef AutomationDef = {
  var task      : Task;
  var scheduler : Scheduler;
}
@:allow(stx.run)
@:using(stx.run.pack.Automation.AutomationLift)
abstract Automation(AutomationDef) from AutomationDef to AutomationDef{
  public function new(self) this = self;
  static public function lift(auto:AutomationDef):Automation{
    return new Automation(auto);
  }
  @:noUsing static public function make(task:Task,scheduler:Scheduler):Automation{
    return lift({ task : task, scheduler : scheduler });
  }
  @:noUsing static public function pure(task:Task):Automation{
    return make(task,Scheduler.ZERO);
  }
  static public function unit():Automation{
    return pure(Task.ZERO);
  }
  @:noUsing static function err(pos:Pos):Report<AutomationFailure<Dynamic>>{
    return Report.pure(__.fault(pos).of(E_Escape(pos)));
  }
  //TODO not sure about the situation with the scheduler here.
  @:noUsing static private function into(handler:Sink<Either<Automation,Report<AutomationFailure<Dynamic>>>>->Void):Automation{
    return pure(Task.fromFuture(
        Future.async((cb:Task->Void) -> 
          handler((either) -> switch(either){
              case Left(auto)         : cb(auto.task);
              case Right(Some(err))   : cb(Task.fromError(err));
              case Right(None)        : cb(Task.unit());
            }
        ))
    ));
  }
  @:noUsing static public function failure(err:Err<AutomationFailure<Dynamic>>):Automation{
    return into((cb) -> cb(Right(Report.pure(err))));
  }
  @:noUsing static public function interim(thk:ReactorDef<Automation>):Automation{
    return into((cb) -> thk.applyII(Noise,(auto) -> cb(Left(auto))));
  }
  @:noUsing inline static public function execute<E>(thk:Void->Option<Err<E>>):Automation{
    var fn : Noise -> Automation = ((_:Noise) -> switch(thk()){
      case Some(err) : failure(__.fault().of(E_Automation(err)));
      case None      : Automation.unit();
    });
    return interim(Reactor.fromNoiseThunk(fn));
  }

  public function prj():AutomationDef return this;
  private var self(get,never):Automation;
  private function get_self():Automation return lift(this);

  private var task(get,never) : Task;
  private function get_task():Task{
    return this.task;
  }
  private var scheduler(get,never) : Scheduler;
  private function get_scheduler():Scheduler{
    return this.scheduler;
  }
}
class AutomationLift{
  static public function mod(self:Automation,fn:Task->Task){
    return Automation.make(fn(self.task),self.scheduler);
  }
  static public function bind(self:Automation,that:Automation,fn:Task -> Task -> Task){
    return Automation.make(fn(self.task,that.task),self.scheduler);
  }
  static public function concat(self:Automation,that:Automation):Automation{
    return bind(self,that,(l,r) -> Task.Seq([l,r].iterator()));
  }
  static public function both(self:Automation,that:Automation):Automation{
    return bind(self,that,(l,r) -> Task.All([l,r].iterator()));
  }
  static public function cons(self:Automation,task:Task):Automation{
    return mod(self,(mine) -> Task.Seq([task,mine].iterator()));
  }
  static public function snoc(self:Automation,task:Task):Automation{
    return mod(self,(mine) -> Task.Seq([mine,task].iterator()));
  }
  static function run(self:Automation,?limit){
    self.scheduler.put(Schedule.Task(self.task));
  }
  static public function submit(self:Automation,?limit){
    run(self,limit);
  }
  static public function stage(self:Automation,before:Void->Void,after:Void->Void){
    return mod(self,
      (task) -> Task.Seq([
        Task.Anon(before),
        task,
        Task.Anon(after)
      ].iterator())
    );
  }
}