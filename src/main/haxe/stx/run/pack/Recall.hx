package stx.run.pack;

typedef RecallT<I,O,R> = I -> (O -> Void) -> R;

@:allow(stx.run.pack.Recall)
@:allow(stx.run.pack.Receiver)
@:callable abstract Recall<I,O,R>(RecallT<I,O,R>){
  public function new(self) this = self;

  static private function lift<I,O,R>(self:RecallT<I,O,R>):Recall<I,O,R> return new Recall(self);
  static public var inj(default,null) = new Constructor();

  public function map<OO>(fn:O->OO) return inj._.map(fn,self);

  public function prj():RecallT<I,O,R> return this;
  private var self(get,never):Recall<I,O,R>;
  private function get_self():Recall<I,O,R> return lift(this);

}
private class Constructor extends Clazz{
  public var _(default,never) = new Destructure();
  public function fromThunk<T>(fn:Void->T):Recall<Noise,T,Void>{
    return Recall.lift((_,cont) -> cont(fn()));
  }
  public function fromNoiseThunk<T>(fn:Noise->T):Recall<Noise,T,Void>{
    return Recall.lift((_,cont) -> cont(fn(Noise)));
  }
}
private class Destructure extends Clazz{
  public function forward<I,O,R>(i:I,rcl:Recall<I,O,R>):Recall<Noise,O,R>{
    return (_,cb) -> rcl(i,cb);
  }
  public function deliver<I,O,R>(cb:O->Void,rcl:Recall<I,O,R>):I -> R{
    return (i) -> rcl(i,cb);
  }
  public function map<I,O,OO,R>(fn:O->OO,rcl:Recall<I,O,R>):Recall<I,OO,R>{
    return lift(
      (i,cont) -> rcl(i,
        (o)->cont(fn(o))
      )
    );
  }
  // public function fmap<I,O,OO,R>(fn:O->Recall<I,OO,R>):Recall<I,OO,R>{
  //   return lift(
  //     (i,cont) -> rcl(i,
  //       (o)-> fn(o)(i,cont)
  //     )
  //   );
  // }
}
