package stx.run.pack;

import stx.run.pack.Task in TaskTask;

//import stx.run.pack.schedule.term.Anon;
import stx.run.pack.schedule.term.Task;

interface ScheduleApi{  
  public var rtid(get,null):Void->Void;
  private function get_rtid():Void->Void;
  
  public function status():Next;
  
  public function pursue():Void;
  public function escape():Void;
  
  public function asScheduleApi():ScheduleApi;

  public function value():Float;//larger value means schedule has seen more usage.
}
@:forward abstract Schedule(ScheduleApi) from ScheduleApi{
  static public function Task(task:TaskTask):Schedule{
    return new Task(task);
  }
  /*@:noUsing static public function Anon(fn):Schedule{
    return new Anon(fn).asScheduleApi();
  }*/
}