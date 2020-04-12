package stx.run.pack.schedule.term;

import stx.run.pack.Task in TaskTask;

class Task extends Base{
  var task : TaskTask;
  var stat : Stat;
  var last : Next;

  public function new(task){
    super();
    this.stat = new Stat(new Clock());
    this.task = task;
  }
  override private function get_rtid():Void->Void{
    return task.rtid;
  }
  override public function status(){
    return last == null ? Busy : last;
  }
  override public function pursue(){
    __.log().close().trace(task.progress.data);
    this.stat.enter();
    switch(task.progress.data){
      case Pending | Working | Polling(_) : 
        task.pursue();
      case Problem(e):
        task.escape();
      case Waiting(_) | Escaped | Secured :
    }
    this.stat.leave();
    this.last = switch(task.progress.data){
      case Pending | Working | Waiting(_)         : Busy;
      case Polling(milliseconds)                  : Poll(milliseconds);
      case Problem(e)                             : Fail(e);
      case Escaped | Secured                      : Exit;
    }
  }
  override public function escape(){
    task.escape();
  }
  override public function value(){
    return this.stat.value();
  }
  public function toString(){
    return 'Schedule($task:${task.progress.data})';
  }
}
class Stat{
  private var clock(default,null):Clock;
  public function new(clock:Clock){
    this.clock            = clock;
    this.accessed         = 0;
    this.total_runtime    = 0;
    this.total_waiting    = 0;
  }
  var last_access(default,null)    : Null<Seconds>;
  var last_runtime(default,null)   : Null<Seconds>;
  var last_waiting(default,null)   : Null<Seconds>;
  
  var total_waiting(default,null)  : Seconds;
  var total_runtime(default,null)  : Seconds;

  var accessed(default,null)       : Int;

  public function enter(){
    this.accessed = this.accessed + 1;
    if(this.last_access != null){
      this.last_waiting   = clock.pure(this.last_access + this.last_runtime).delta();
      this.total_waiting  = this.total_waiting + this.last_waiting;
    }
    this.last_access  = clock.stamp();
  }
  public function leave(){
    this.last_runtime = clock.pure(last_access).delta();
    total_runtime     = last_runtime + total_runtime;
  }
  public function value():Float{
    //trace('$total_waiting $total_runtime');
    var a           = (total_waiting / total_runtime );
    var b : Seconds = accessed + 1;
    var c           = a * b;
    var d           = @:privateAccess c.prj();
    return d;
  }
}