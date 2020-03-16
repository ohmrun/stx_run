package stx.run.pack.reactor;

import stx.run.pack.recall.term.Anon;
import stx.run.pack.recall.term.Never;
import stx.run.pack.recall.term.Pure;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new stx.run.pack.reactor.Constructor();
  public var _(default,never)           = new Destructure();
  
  @:deprecated
  public function unit<T>():Reactor<T>{
    return new Never().asRecallDef();
  }
  public inline function pure<T>(v:T):Reactor<T>{
    return new Pure(v).asRecallDef();
  }
  public inline function into<T>(cb:(T->Void) -> Void):Reactor<T>{
    return Reactor.Anon(
      (_:Noise,cont:T->Void) -> cb(cont)
    );
  }
  public function bind_fold<T,R>(arr:Array<T>,fn:T->R->Reactor<R>,init:R):Reactor<R>{
    return arr.lfold(
      (next:T,memo:Reactor<R>) -> memo.fmap(
        (r) -> fn(next,r)
      ),
      pure(init)
    );
  }
  public function any<T>(arr:Array<Reactor<T>>):Option<Reactor<T>>{
    return arr.lfold1(_.or);
  }
  public function fromNoiseThunk<T>(fn:Noise->T):Reactor<T>{
    return into((cont) -> cont(fn(Noise)));
  }
  public function fromThunk<T>(fn:Void->T):Reactor<T>{
    return into((cont) -> cont(fn()));
  }
  public function Anon<T>(fn:RecallFun<Noise,T,Void>):Reactor<T>{
    return new Anon(fn);
  }
}