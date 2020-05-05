package stx.run.pack;

import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.All;
import stx.run.pack.task.term.Seq;
import stx.run.pack.task.term.Anon;
import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.Both;
import stx.run.pack.task.term.Error;
import stx.run.pack.task.term.Unit;
import stx.run.pack.task.term.Timeout;
import stx.run.pack.task.term.When;
import stx.run.pack.task.term.On;
import stx.run.pack.task.term.Blocking;

interface TaskApi{
  //public var declared(default,null): Pos;
  
  public var rtid(default,null): Void->Void;
  public var progress(get,set): Progression;

  private function get_progress():Progression;
  private function set_progress(ts:Progression):Progression;

  public function pursue():Void;
  public function escape():Void;

  public function asTaskApi():TaskApi;
  public function toString():String;
}

@:forward abstract Task(TaskApi) from TaskApi to TaskApi{
  static public var ZERO(default,null) : Task = new Task(new Base());
  public function new(self) this = self;
  
  
  public function seq(that:Task):Task{
    return new Seq([self,that].iterator());
  }

  @:to public function toAutomation(){return this;}

  @:noUsing static public function Seq(gen):Task{
    return new Seq(gen);
  }
  @:noUsing static public function Anon(execute:Void->Void,?release:Void->Void,?cleanup:Void->Void):Task{
    return new Anon(execute,release,cleanup);
  }
  @:noUsing static public inline function fromFuture(ft:Future<Task>):Task{
    return new Deferred(ft);
  }
  @:noUsing static public function fromError<E>(err:Err<RunFailure<E>>):Task{
    return new Error(err);
  }
  static public function unit():Task{
    return new Unit();
  }
  @:noUsing static public function On(bang:FutureTrigger<Noise>):Task{
    return new On(bang);
  }
  @:noUsing static public function Timeout(milliseconds):Task{
    return new Timeout(milliseconds);
  }
  @:noUsing static public function All(array:Array<Task>):Task{
    return new All(array);
  }
  @:noUsing static public function Blocking(ref:Ref<Bool>):Task{
    return new Blocking(ref);
  }
  @:noUsing static public function Both(lhs:Task,rhs:Task):Task{
    return new Both(lhs,rhs);
  }
  @:noUsing static public function Err(e):Task{
    return new stx.run.pack.task.term.Err(e);
  }
  @:noUsing static public function Error(e):Task{
    return new stx.run.pack.task.term.Error(e);
  }
  private var self(get,never):Task;
  private function get_self():Task return this;
}