package stx.run.pack;

@:using(stx.run.pack.bang.Implementation)
class Bang extends stx.run.pack.recall.term.Base<Noise,Noise,Void>{
  static public inline function inj() return stx.run.pack.bang.Constructor.ZERO;
}