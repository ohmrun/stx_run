package stx.run.pack.recall;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();
  
  public function fromThunk<T>(fn:Void->T):Recall<Noise,T,Void>{
    return Recall.anon((_,cont) -> cont(fn()));
  }
  public function fromNoiseThunk<T>(fn:Noise->T):Recall<Noise,T,Void>{
    return Recall.anon((_,cont) -> cont(fn(Noise)));
  }
}