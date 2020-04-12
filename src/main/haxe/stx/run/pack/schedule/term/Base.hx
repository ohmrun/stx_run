package stx.run.pack.schedule.term;

class Base implements ScheduleApi{
  public var rtid(get,null):Void->Void;
  private function get_rtid():Void->Void{
    return ()->{}
  }
  public function new(){
    //this.stat = new Stat();  
  }
  public function status():Next{
    throw __.fault().err(E_AbstractMethod);
  }
  public function escape(){
    throw __.fault().err(E_AbstractMethod);
  }
  public function pursue(){
    throw __.fault().err(E_AbstractMethod);
  }
  public function value():Float{
    throw __.fault().err(E_AbstractMethod);
  }
  public function asScheduleApi():ScheduleApi{
    return this;
  }
}