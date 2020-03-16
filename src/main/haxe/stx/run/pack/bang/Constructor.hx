package stx.run.pack.bang;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();

  public var _ = new Destructure();
  
  public function unit():Bang{
    return Reactor.into(
      (handler) -> handler(Noise)
    ).asRecallDef();
  }
  public function fromFuture(ft:Future<Noise>):Bang{
    return Recall.Anon(
      (_:Noise,cb) -> ft.handle(cb)
    );
  }
}