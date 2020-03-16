package stx.run.pack.schedule.term;

class Base implements ScheduleApi{
  public function new(){}
  public function reply():Tick{
    return Exit;
  }
  public function asScheduleApi():ScheduleApi{
    return this;
  }
}