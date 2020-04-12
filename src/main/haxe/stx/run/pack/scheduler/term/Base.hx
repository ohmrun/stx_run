package stx.run.pack.scheduler.term;
 
import haxe.ds.ArraySort;
import haxe.MainLoop;

class Base implements SchedulerApi{
  
  public function new(){
    error   = None;
    picker  = new Picker();
  }

  var picker      : Picker;
  var error       : Option<Err<Dynamic>>;

  public function put(schedule:Schedule):Void{
    __.log().close().trace('Scheduler#put(schedule) $this');
    var sleeping = status();
    picker.put(schedule);
    if(sleeping.match(Exit)){
      Runtime.run(this);
    }
  }
  public function status(){
    return error.map(Fail).def(
      () -> __.option(picker.peek()).map( schedule -> schedule.status()  ).defv(Exit)
    );
  }
  public function pursue(){ 
    __.log().close().trace('Scheduler.Base#pursue ${picker.size()}');
    var head  = picker.pop(); 
    if(head==null || error.is_defined()){
      return;
    }
    switch(head.status()){
      case Exit               : 
      case Poll(_) | Busy     :
        head.pursue();
        switch(head.status()){
          case Poll(_) | Busy : 
            picker.put(head);
          default : 
        }
      case Fail(e)            :
        picker.escape();
        this.error =  Some(e);
    }
  }
  public function escape(){
    picker.escape();
  }
  public function asSchedulerApi():SchedulerApi{
    return this;
  }
  public function toString(){
    return 'Scheduler#Base([${picker}] status:${status()})';
  }
}
class Picker{
  var data : Array<Schedule>;
  public function new(){
    this.data = [];
  }
  public function pop():Schedule{
    return data.shift();
  }
  public function put(schedule:Schedule):Void{
    if(!data.contains(schedule)){
      this.data.push(schedule);
    }
    ArraySort.sort(this.data,eq);
  }
  private function eq(l:Schedule,r:Schedule):Int{
    return Math.round(l.value()  - r.value());
  }
  public function peek():Schedule{
    return data[0];
  }
  public function escape(){
    for(schedule in data){
      schedule.escape();
    }
  }
  public function is_defined(){
    return this.data.is_defined();
  }
  public function size(){
    return this.data.length;
  }
  public function toString():String{
    return this.data.join(",");
  }
}