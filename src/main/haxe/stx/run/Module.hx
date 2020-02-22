package stx.run;

import stx.run.module.*;

class Module{
  public function new(){}
  public inline function observer<T>():Unary<T,Observer<T>>{
    return Observer.pure;
  }
  public inline function receiver<T>():Unary<Observer<T>,Receiver<T>>{
    return (obs) -> stx.run.pack.Receiver.lift((next) -> 
      __.perform( 
        () -> obs(next)  
      )(Task.NOOP.toAutomation())
    );
  }

  public inline function task(execute:Void->Void,?release:Void->Void,?cleanup:Void->Void):Task{
    return new stx.run.pack.AnonymousTask(execute,release,cleanup);
  }
  public inline function conduct<O>(fn:O->Void,o:O):Task{
    return perform(fn.bind(o));
  }
  public inline function perform(fn:Void->Void):Task{
    return task(fn);
  }
  public inline function deferred(obs:Observer<Task>):Task{
    return new Deferred(obs);
  }
  public inline function bang():Bang{
    return Bang.unit();
  }
  public function Waiter()    return new stx.run.module.Waiters();
 
}