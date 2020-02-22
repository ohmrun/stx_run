package stx.run.pack;

import stx.run.head.data.Task in TaskT;

@:forward abstract Task(TaskT) from TaskT to TaskT{
  static public var NOOP(default,null) : Task = new Task(new TaskBase());
  public function new(self){
    this = self;
  }
  @:to public function toAutomation(){
    return Automation.pure(JobQueue.lift([this]));
  }
}


 