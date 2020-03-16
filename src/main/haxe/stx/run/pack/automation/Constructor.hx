package stx.run.pack.automation;

@:access(stx.run.pack.automation) class Constructor{
  static public var ZERO(default,never) = new Constructor();
  
  public var _(default,never) = new Destructure();

  private function new(){}

  public function lift(auto:AutomationDef):Automation{
    return new Automation(auto);
  }
  function err(pos:Pos):Report<AutomationFailure<Dynamic>>{
    return Report.pure(__.fault(pos).of(E_Escape(pos)));
  }
  public function into(handler:Sink<Either<Automation,Report<AutomationFailure<Dynamic>>>>->Void):Automation{
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
  public function failure(err:TypedError<AutomationFailure<Dynamic>>):Automation{
    return into((cb) -> cb(Right(Report.pure(err))));
  }
  public function interim(thk:ReactorDef<Automation>):Automation{
    return into((cb) -> thk.duoply(Noise,(auto) -> cb(Left(auto))));
  }
  inline public function execute<E>(thk:Void->Option<TypedError<E>>):Automation{
    var fn : Noise -> Automation = ((_:Noise) -> switch(thk()){
      case Some(err) : failure(__.fault().of(E_Automation(err)));
      case None      : Automation.unit();
    });
    return interim(Reactor.fromNoiseThunk(fn));
  }
  public function unit(){
    return Task.unit();
  }
}