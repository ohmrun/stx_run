package stx.run.pack;

@:using(stx.run.pack.Automation.AutomationLift)
abstract Automation(AutomationDef) from AutomationDef to AutomationDef{
  public function new(self) this = self;
  static public function unit()
    return lift(Task.ZERO);

  static public function lift(auto:AutomationDef):Automation{
    return new Automation(auto);
  }
  static function err(pos:Pos):Report<AutomationFailure<Dynamic>>{
    return Report.pure(__.fault(pos).of(E_Escape(pos)));
  }
  static public function into(handler:Sink<Either<Automation,Report<AutomationFailure<Dynamic>>>>->Void):Automation{
    return Task.fromReactor(
      Reactor.into(
        (cb:Automation->Void) -> 
          handler((either) -> switch(either){
              case Left(auto)         : cb(auto);
              case Right(Some(err))   : cb(Task.fromError(err));
              case Right(None)        : cb(Task.unit());
            }
          )
      )
    );
  }
  static public function failure(err:Err<AutomationFailure<Dynamic>>):Automation{
    return into((cb) -> cb(Right(Report.pure(err))));
  }
  static public function interim(thk:ReactorDef<Automation>):Automation{
    return into((cb) -> thk.applyII(Noise,(auto) -> cb(Left(auto))));
  }
  inline static public function execute<E>(thk:Void->Option<Err<E>>):Automation{
    var fn : Noise -> Automation = ((_:Noise) -> switch(thk()){
      case Some(err) : failure(__.fault().of(E_Automation(err)));
      case None      : Automation.unit();
    });
    return interim(Reactor.fromNoiseThunk(fn));
  }

  public function prj():AutomationDef return this;
  private var self(get,never):Automation;
  private function get_self():Automation return lift(this);
}
class AutomationLift{
  static public function concat(self:Automation,that:Automation):Automation{
    return Task.Seq([self.prj(),that.prj()].iterator());
  }
  static public function both(self:Automation,that:Automation):Automation{
    return Task.All([that.prj(),self.prj()].iterator());
  }
  static public function cons(self:Automation,task:Task):Automation{
    return Task.Seq([task,self].iterator());
  }
  static public function snoc(self:Automation,task:Task):Automation{
    return Task.Seq([self,task].iterator());
  }
  static function run(self:Automation,?limit){

    var schedule = Schedule.Task(self);

    Run.unit().upply(schedule);
  }
  static public function submit(self:Automation,?limit){
    run(self,limit);
  }
}