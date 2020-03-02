package stx.run.pack.automation;

import stx.run.type.Package.Automation in AutomationT;

@:access(stx.run.pack.automation) class Constructor{
  public var _(default,null) = new Destructure();

  private function new(){}

  public function lift(auto:AutomationT):Automation{
    return new Automation(auto);
  }
  public function unit():Automation{
    return Queue.unit().automation();
  }
  public function pure(jobs:Queue):Automation{
    return jobs.automation();
  }
  public function default_(err:TypedError<AutomationFailure<Dynamic>>):Automation{
    return lift(Default(err));
  }
  public function interim(thk:ReactorDef<Automation>):Automation{
    return lift(Interim(thk.map(_ -> _.prj())));
  }
  public function yield(arw:ReactorDef<Automation>):Automation{
    return interim(arw);
  }
  // inline public function conduct<O>(cb:Reactor<O>,at:(O->Void)){
  //   var fn = (next:Automation->Void) -> {
  //     var fn0 = cb.prj().bind(
  //       (o) -> next(Task.inj.pursue(at.bind(o)))
  //     );
  //     var exec  = Task.inj.pursue(fn0);
  //     return exec.toAutomation();
  //   };
  //   return interim(Receiver.lift(fn));
  // }
  inline public function execute<E>(thk:Void->Option<TypedError<E>>):Automation{
    var fn : Noise -> Automation = ((_:Noise) -> switch(thk()){
      case Some(err) : default_(__.fault().of(HaltedAt(err)));
      case None      : Queue.unit().automation();
    });
    return yield(Reactor.inj().fromNoiseThunk(fn));
  }
}