package stx.run.pack;

import stx.run.pack.Task in TaskDef;

import stx.run.pack.schedule.term.Anon;
import stx.run.pack.schedule.term.Task;

@:forward abstract Schedule(ScheduleApi) from ScheduleApi{

  static public function Task(task:TaskDef):Schedule{
    return new Task(task);
  }
  static public function Anon(fn):Schedule{
    return new Anon(fn).asScheduleApi();
  }
}