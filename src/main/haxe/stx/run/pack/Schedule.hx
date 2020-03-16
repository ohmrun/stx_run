package stx.run.pack;

import stx.run.pack.Task in TaskDef;

import stx.run.pack.schedule.term.Anon;
import stx.run.pack.schedule.term.Task;

@:forward abstract Schedule(ScheduleApi) from ScheduleApi{
  static public inline function _() return Constructor.ZERO;
  static public function Task(task:TaskDef):Schedule   return _().Task(task);
  static public function Anon(fn):Schedule             return _().Anon(fn);
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function Task(task:TaskDef):Schedule{
    return new Task(task);
  }
  public function Anon(fn):Schedule{
    return new Anon(fn).asScheduleApi();
  }
}
private class Destructure extends Clazz{
  
}