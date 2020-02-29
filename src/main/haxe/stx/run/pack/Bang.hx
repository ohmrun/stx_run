package stx.run.pack;

import stx.run.head.data.Bang in BangT;

abstract Bang(BangT) from BangT to BangT{
  static public var __(default,null) = new Constructor();
  //static public var _(default,null)  = __._;

  public function new(self) this = self;
  static public function lift(self:BangT):Bang    return __.lift(self);
  static public function unit():Bang              return __.unit();

  
  public function perform(fn:Void->Void):Bang{
    return lift(this.prj().map(__.command(x)));
  }
  public function prj():BangT return this;
  private var self(get,never):Bang;
  private function get_self():Bang return lift(this);
}
private class Constructor{
  public function new(){}
  public function lift(self:BangT):Bang return new Bang(self);
  public function unit():Bang{
    return lift(
      UIO.inj.call(
        (handler) -> handler(Noise)
      )
    );
  }
}