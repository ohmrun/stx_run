package stx.run.pack;

import stx.run.head.data.Bang in BangT;

abstract Bang(BangT) from BangT to BangT{
  public function new(self) this = self;
  static public function lift(self:BangT):Bang return new Bang(self);
  static public function unit():Bang return Bangs.unit();

  
  public function perform(fn:Void->Void):Bang{
    return lift((auto) -> {
      fn();
      return this(auto);
    });
  }
  public function prj():BangT return this;
  private var self(get,never):Bang;
  private function get_self():Bang return lift(this);
}
class Bangs{
  static public function unit():Bang{
  return Bang.lift((auto) -> __.run().observer()(Noise).toReceiver());
  }
}