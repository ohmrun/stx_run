package stx.run.pack;

@:using(stx.run.pack.io.Implementation)
@:forward abstract IO<O,E>(IODef<O,E>) from IODef<O,E> to IODef<O,E>{
  static public inline function _():stx.run.pack.io.Constructor return stx.run.pack.io.Constructor.ZERO;

  static public function pure<R>(r:R):IO<R,Noise>                                                     return _().pure(r);

  static public function feed<O,E>(handler:(Res<O,E>->Void)->Automation):IO<O,E>                  return _().feed(handler);
  static public function call<O,E>(handler:(Res<O,E>->Void)->Void):IO<O,E>                        return _().call(handler);

  @:from static public function fromFunXR<R>(thk:Void -> R):IO<R,Noise>                               return _().fromFunXR(thk);
  @:from static public function fromFunXRes<R,E>(chk:Void -> Res<R,E>):IO<R,E>                return _().fromFunXRes(chk);
  @:from static public function fromFun1R<E,R>(fn:Noise -> Res<R,E>):IO<R,E>                      return _().fromFun1R(fn);
  
  static public function fromUIODef<O>(fn:Recall<Automation,O,Automation>):IO<O,Dynamic>              return _().fromUIODef(fn);
  static public function fromIODef<O,E>(fn:Automation->(Res<O,E>->Void)->Automation):IO<O,E>      return _().fromIODef(fn);
  
  @:from static public function fromRes<R,E>(chk:Res<R,E>):IO<R,E>                            return _().fromRes(chk);

  
  
  static public function fromFunXIO<E,R>(fn:Unary<Noise,IODef<R,E>>):IODef<R,E>                       return _().fromFunXIO(fn);

  static public function bind_fold<A,E,R>(fn:A->R->IO<R,E>,arr:Array<A>,r:R):IODef<R,E>               return _().bind_fold(fn,arr,r);
}