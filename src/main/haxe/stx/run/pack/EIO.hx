package stx.run.pack;

@:using(stx.run.pack.eio.Implementation)
class EIO<E> extends stx.run.pack.recall.term.Base<Automation,E,Automation>{
  static public inline function inj() return stx.run.pack.eio.Constructor.ZERO;
}