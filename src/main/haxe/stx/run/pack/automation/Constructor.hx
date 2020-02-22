package stx.run.pack.automation;

class Constructor{
  private function new(){}
  public var _(default,null) = new Destructure();

  public function lift(auto:Type):Automation{
    return new Automation(auto);
  }
  public function unit():Automation{
    return JobQueue.unit().automation();
  }
  public function pure(jobs:JobQueue):Automation{
    return jobs.automation();
  }
  public function error(err:TypedError<AutomationFailure<Dynamic>>):Automation{
    return lift(Default(err));
  }
  public function later(thk:Receiver<Automation>):Automation{
    return lift(Interim(thk.map(_->_.prj())));
  }
  public function yield(arw:Arrowlet<Noise,Automation>):Automation{
    return lift(Yield(JobQueue.unit(),arw.then((x:Automation)->x.prj())));
  }
  inline public function conduct<O>(cb:Observer<O>,at:(O->Void)){
    var fn = (next:Automation->Void) -> {
      var fn0 = cb.prj().bind(
        (o) -> {
          next(
            __.run().perform(at.bind(o))
          );
        }
      );
      var exec  = __.run().perform(fn0);
      return exec.toAutomation();
    };
    return later(Receiver.lift(fn));
  }
  inline public function execute<E>(thk:Void->Option<TypedError<E>>):Automation{
    var fn : Noise -> Automation = ((_:Noise) -> switch(thk()){
      case Some(err) : error(__.fault().of(HaltedAt(err)));
      case None      : JobQueue.unit().automation();
    });
    return yield(__.arw().fn()(fn));
  }
}