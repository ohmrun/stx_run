package stx.run.pack;

import stx.run.type.Package.Automation  in AutomationT;


@:using(stx.run.pack.io.Implementation)
class Receiver<T> extends stx.run.pack.recall.term.Base<Noise,T,Automation>{
  static public inline function inj() return stx.run.pack.receiver.Constructor.ZERO;
}