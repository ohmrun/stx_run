package stx.run.pack;

import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.All;
import stx.run.pack.task.term.Seq;
import stx.run.pack.task.term.Anon;
import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.Error;
import stx.run.pack.task.term.Unit;
import stx.run.pack.task.term.Timeout;

interface TaskApi{
  public var progress(get,set): Progression;
  function get_progress():Progression;
  function set_progress(ts:Progression):Progression;

  public var working(get,null): Bool;
  function get_working():Bool;

  public var ongoing(get,null): Bool;
  function get_ongoing():Bool;

  public function pursue():Void;
  public function escape():Void;

  public function asTaskApi():TaskApi;

  public function toDeferred():TaskApi;
  public function toSchedule():Schedule;
}

@:forward abstract Task(TaskApi) from TaskApi to TaskApi{
  static public var ZERO(default,null) : Task = new Task(new Base());
  public function new(self) this = self;
  
  
  public function seq(that:Task):Task{
    return new Seq([self,that].iterator());
  }

  @:to public function toAutomation(){return this;}

  static public function Seq(gen):Task{
    return new Seq(gen);
  }
  static public function Anon(execute:Void->Void,?release:Void->Void,?cleanup:Void->Void):Task{
    return new Anon(execute,release,cleanup);
  }
  static public inline function fromReactor(obs:Reactor<Task>):Task{
    return new Deferred(obs);
  }
  static public inline function fromFuture(ft:Future<Task>):Task{
    return fromReactor(
      Reactor.into(
        (cb) -> {
          var canceller : CallbackLink = null;
            var fn        = () -> {
            if(canceller!=null){ canceller.cancel(); }
          }
          var next       = Anon(()->{},fn);
          canceller      = ft.handle((task:Task) -> cb(task.seq(next)));
        }
      )
    );
  }
  static public function fromError(err:Err<AutomationFailure<Dynamic>>):Task{
    return new Error(err);
  }
  static public function unit():Task{
    return new Unit();
  }
  static public function Timeout(milliseconds):Task{
    return new Timeout(milliseconds);
  }
  static public function All(iterator:Iterator<Task>):Task{
    return new All(iterator);
  }
  private var self(get,never):Task;
  private function get_self():Task return this;
}