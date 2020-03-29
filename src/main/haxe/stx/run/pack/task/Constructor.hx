package stx.run.pack.task;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function Seq(gen):Task{
    return new Seq(gen);
  }
  public function Anon(execute:Void->Void,?release:Void->Void,?cleanup:Void->Void):Task{
    return new Anon(execute,release,cleanup);
  }
  public inline function fromReactor(obs:Reactor<Task>):Task{
    return new Deferred(obs);
  }
  public inline function fromFuture(ft:Future<Task>):Task{
    return fromReactor(
      Reactor._().into(
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
  public function fromError(err:Err<AutomationFailure<Dynamic>>):Task{
    return new Error(err);
  }
  public function unit():Task{
    return new Unit();
  }
  @:deprecated
  public function timeout(milliseconds):Task{
    return new Timeout(milliseconds);
  }
  public function Timeout(milliseconds):Task{
    return new Timeout(milliseconds);
  }
  public function All(generator:Void->Option<Task>):Task{
    return new All(generator);
  }
}