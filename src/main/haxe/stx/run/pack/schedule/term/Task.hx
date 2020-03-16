package stx.run.pack.schedule.term;

import stx.run.pack.Task in TaskApi;

class Task extends Base{
  var task : TaskApi;
  public function new(task){
    super();
    this.task = task;
  }
  override function reply(){
    __.log().close().trace(task.progress.data);
    return switch(task.progress.data){
      case Pending : 
        task.pursue();
        Busy;
      case Polling(milliseconds):  
        task.pursue();
        Poll(milliseconds);
      case Waiting(cb):
        task.pursue();
        Busy;
      case Problem(e):
        task.escape();
        Fail(e);
      case Escaped | Secured :
        Exit;
    }
  }
}