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
    __.log().trace(task);
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
