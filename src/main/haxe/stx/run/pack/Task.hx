package stx.run.pack;

import stx.run.pack.task.term.Anon;
import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Base;

import stx.run.pack.task.Interface in TaskT;

@:forward abstract Task(TaskT) from TaskT to TaskT{
  static public var NOOP(default,null) : Task = new Task(new Base());
  static public var inj(default,null)         = new Constructor();
  public function new(self) this = self;

  
  
  @:to public function toAutomation(){
    return Automation.pure(Queue.lift([this]));
  }
}
private class Constructor{
  public function new(){}

  public function anon(execute:Void->Void,?release:Void->Void,?cleanup:Void->Void):Task{
    return new Anon(execute,release,cleanup);
  }
  public inline function pursue(fn:Void->Void):Task{
    return anon(fn);
  }
  public inline function conduct<O>(fn:O->Void,o:O):Task{
    return pursue(fn.bind(o));
  }
  public inline function deferred(obs:Reactor<Task>):Task{
    return new Deferred(obs);
  }
}