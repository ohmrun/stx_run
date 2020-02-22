package stx.run.head;
import stx.run.head.data.Automation in AutomationT;

class Automations{
  static public var _(default,null) = new stx.run.body.Automations();

  static public function lift(auto:AutomationT):Automation{
    return new Automation(auto);
  }
  static public function unit():Automation{
    return JobQueue.unit().automation();
  }
  static public function pure(jobs:JobQueue):Automation{
    return jobs.automation();
  }
  static public function error(err:TypedError<AutomationFailure<Dynamic>>):Automation{
    return lift(Ended(End(err)));
  }
  @:noUsing static public function later(thk:Receiver<Automation>):Automation{
    return lift(Later(thk.map(_->_.prj())));
  }
  @:noUsing static public function yield(arw:Arrowlet<Noise,Automation>):Automation{
    return lift(Yield(JobQueue.unit(),arw.then((x:Automation)->x.prj())));
  }
  @:noUsing static public inline function conduct<O>(cb:Observer<O>,at:(O->Void)){
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
  @:noUsing static public inline function execute<E>(thk:Void->Option<TypedError<E>>):Automation{
    var fn : Noise -> Automation = ((_:Noise) -> switch(thk()){
      case Some(err) : error(__.fault().of(HaltedAt(err)));
      case None      : JobQueue.unit().automation();
    });
    return yield(__.arw().fn()(fn));
  }
}