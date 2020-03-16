package stx.run.pack;

@:using(stx.run.pack.bang.Implementation)
@:forward abstract Bang(BangDef) from BangDef to BangDef {
  static public inline function _() return stx.run.pack.bang.Constructor.ZERO;

  public function perform(fn) _()._.perform(fn,this);
}