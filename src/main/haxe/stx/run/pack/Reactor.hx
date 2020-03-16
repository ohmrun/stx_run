package stx.run.pack;

import stx.run.pack.recall.term.Base;

@:using(stx.run.pack.reactor.Implementation)
@:forward abstract Reactor<T>(ReactorDef<T>) from ReactorDef<T> to ReactorDef<T>{
  static public function _() return stx.run.pack.reactor.Constructor.ZERO;

  static public function pure<T>(t:T):Reactor<T>                                              return _().pure(t);

  static public function Anon<T>(fn:RecallFun<Noise,T,Void>):Reactor<T>                       return _().Anon(fn);
  static public function fromNoiseThunk<T>(fn:Noise->T):Reactor<T>                            return _().fromNoiseThunk(fn);

  static public function into<T>(cb:(T->Void) -> Void):Reactor<T>                             return _().into(cb);
  static public function any<T>(arr:Array<Reactor<T>>):Option<Reactor<T>>                     return _().any(arr);

  static public function bind_fold<T,R>(arr:Array<T>,fn:T->R->Reactor<R>,init:R):Reactor<R>   return _().bind_fold(arr,fn,init);
}