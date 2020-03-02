package stx.run.pack.bang;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();

  public var _ = new Destructure();
  
  public function unit():BangDef{
    return Reactor.inj().into(
      (handler) -> handler(Noise)
    ).prj();
  }
}