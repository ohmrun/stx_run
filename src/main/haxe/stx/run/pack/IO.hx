package stx.run.pack;

@:using(stx.run.pack.io.Implementation)
@:forward abstract IO<T,E>(IODef<T,E>) from IODef<T,E> to IODef<T,E>{
  static public inline function _() return stx.run.pack.io.Constructor.ZERO;

  static public function pure<R>(r:R):IO<R,Noise>                                                 return _().pure(r);
  static public function feed<T,E>(handler:(Outcome<T,E>->Void)->Automation)                      return _().feed(handler);
  static public function call<T,E>(handler:(Outcome<T,E>->Void)->Void)                            return _().call(handler);
  static public function fromUIOT<T>(fn:Recall<Automation,T,Automation>):IO<T,Dynamic>            return _().fromUIOT(fn);
  static public function fromIOT<O,E>(fn:Automation->(Outcome<O,E>->Void)->Automation):IO<O,E>    return _().fromIOT(fn);
  static public function fromOutcomeThunk<R,E>(chk:Thunk<Outcome<R,E>>):IO<R,E>                   return _().fromOutcomeThunk(chk);
  static public function fromOutcome<R,E>(chk:Outcome<R,E>):IO<R,E>                               return _().fromOutcome(chk);
  static public function fromThunk<R>(thk:Thunk<R>):IO<R,Noise>                                   return _().fromThunk(thk);
  static public function fromUnary<E,R>(fn:Unary<Noise,Outcome<R,E>>):IO<R,E>                     return _().fromUnary(fn);
  static public function fromUnaryConstructor<E,R>(fn:Unary<Noise,IO<R,E>>):IO<R,E>               return _().fromUnaryConstructor(fn);
  static public function bfold<A,E,R>(fn:A->R->IO<R,E>,arr:Array<A>,r:R):IODef<R,E>               return _().bfold(fn,arr,r);
}