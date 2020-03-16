package stx.run.pack.recall;

import stx.run.pack.recall.term.Anon;
import stx.run.pack.recall.term.Pure;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();
  
  public function fromThunk<T>(fn:Void->T):RecallDef<Noise,T,Void>{
    return Anon((_,cont) -> cont(fn()));
  }
  public function fromNoiseThunk<T>(fn:Noise->T):RecallDef<Noise,T,Void>{
    return Anon((_,cont) -> cont(fn(Noise)));
  }
  public inline function pure<I,O,R>(o:O):RecallDef<I,O,R>{
    return new Pure(o);
  }
  @:deprecated
  public inline function anon<I,O,R>(fn:RecallFun<I,O,R>):RecallDef<I,O,R>{
    return new Anon(fn).asRecallDef();
  }
  public inline function Anon<I,O,R>(fn:RecallFun<I,O,R>):RecallDef<I,O,R>{
    return new Anon(fn).asRecallDef();
  }
}