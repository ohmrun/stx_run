package stx.run.pack;

@:using(stx.run.pack.waiter.Implementation)
class Waiter<T,E> extends stx.run.pack.recall.term.Base<Automation,Outcome<T,E>,Automation>{
  static public inline function inj() return stx.run.pack.waiter.Constructor.ZERO;
}