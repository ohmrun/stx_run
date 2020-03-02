package stx.run.pack;

@:using(stx.run.pack.uio.Implementation)
class UIO<T> extends stx.run.pack.recall.term.Base<Automation,T,Automation>{
  static public inline function inj() return stx.run.pack.uio.Constructor.ZERO;

}