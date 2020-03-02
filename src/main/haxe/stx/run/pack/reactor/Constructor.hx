package stx.run.pack.reactor;

import stx.run.type.Package.ReactorDef;

import stx.run.pack.recall.term.Never;
import stx.run.pack.recall.term.Pure;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new stx.run.pack.reactor.Constructor();
  public var _(default,never)           = new Destructure();
  
  public function unit<T>():ReactorDef<T>{
    return new Never();
  }
  public inline function pure<T>(v:T):ReactorDef<T>{
    return new Pure(v);
  }
  public inline function into<T>(cb:(T->Void) -> Void):ReactorDef<T>{
    return Reactor.anon(
      (_:Noise,cont:T->Void) -> cb(cont)
    );
  }
  public function bind_fold<T,R>(arr:Array<T>,fn:T->R->ReactorDef<R>,init:R):ReactorDef<R>{
    return arr.lfold(
      (next:T,memo:ReactorDef<R>) -> memo.fmap(
        (r) -> fn(next,r)
      ),
      pure(init)
    );
  }
  public function any<T>(arr:Array<ReactorDef<T>>):Option<ReactorDef<T>>{
    return arr.lfold1(_.or);
  }
  public function fromNoiseThunk<T>(fn:Noise->T):ReactorDef<T>{
    return into((cont) -> cont(fn(Noise)));
  }
  public function fromThunk<T>(fn:Void->T):ReactorDef<T>{
    return into((cont) -> cont(fn()));
  }
}