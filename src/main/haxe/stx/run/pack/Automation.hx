package stx.run.pack;

import stx.run.pack.uio.Typedef in UIOT;
import stx.run.pack.automation.Typedef in AutomationT;
import stx.run.pack.automation.Constructor;

@:access(stx.run.pack.automation) abstract Automation(AutomationT) from AutomationT to AutomationT{
  public function new(self:AutomationT) this = self;
  static public var inj(default,null)       = new stx.run.pack.automation.Constructor();

  static public inline function lift(self:AutomationT)          return new Automation(self);

  @:noUsing static public function fromTask(t:Task)             return lift(Release(Queue.unit().snoc(t)));
  @:noUsing static public function unit<E>():Automation         return inj.unit();
  @:noUsing static public function pure<E>(jobs):Automation     return inj.pure(jobs);

  public function seq(fn:Queue->Automation):Automation          return inj._.seq(fn,self);
  public function mod(fn:Queue->Queue):Automation               return inj._.mod(fn,self);


  public function concat(that)                                  return inj._.concat(that,self);
  public function snoc(task)                                    return inj._.snoc(task,self);
  public function cons(that:Task):Automation                    return inj._.cons(that,self);


  public function crunch()                                      return inj._.crunch(self);
  public function submit()                                      return inj._.submit(self);

  public function prj():AutomationT return this;
  private var self(get,never):Automation;
  private function get_self():Automation return lift(this);
}