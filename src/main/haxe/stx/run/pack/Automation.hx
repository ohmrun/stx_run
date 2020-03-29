package stx.run.pack;

import stx.run.pack.automation.Constructor;

@:access(stx.run.pack.automation) abstract Automation(AutomationDef) from AutomationDef to AutomationDef{
  public function new(self:AutomationDef) this = self;
  static public inline function _() return stx.run.pack.automation.Constructor.ZERO;

  static public function lift(self:AutomationDef):Automation                                                         return new Automation(self);
  static public function unit()                                                                                      return lift(Task.ZERO);

  static public function into(handler:Sink<Either<Automation,Report<AutomationFailure<Dynamic>>>>->Void):Automation  return _().into(handler);
  static public function failure(err:Err<AutomationFailure<Dynamic>>):Automation                              return _().failure(err);
  static public function interim(thk:ReactorDef<Automation>):Automation                                              return _().interim(thk);
  static public function execute<E>(thk:Void->Option<Err<E>>):Automation                                      return _().execute(thk);


  public function snoc(task)                                      return _()._.snoc(task,self);
  public function cons(that:Task):Automation                      return _()._.cons(that,self);
  
  public function submit()                                        return _()._.submit(self);

  public function prj():AutomationDef return this;
  private var self(get,never):Automation;
  private function get_self():Automation return lift(this);
 
}