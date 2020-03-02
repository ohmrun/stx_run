package stx.run.pack;

import stx.run.pack.recall.term.Base;

@:using(stx.run.pack.reactor.Implementation)
class Reactor<T> extends Base<Noise,T,Void>{
  static public function inj() return stx.run.pack.reactor.Constructor.ZERO;
  static public function anon<T>(fn:RecallFunction<Noise,T,Void>){
    return new stx.run.pack.reactor.term.Anon(fn);
  }
}
// class Reactor<T> extends stx.run.pack.recall.term.Base<Noise,T,Void>{
//   static public inline function inj() return stx.run.pack.io.Constructor.ZERO;
// }