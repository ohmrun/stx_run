package stx.run.pack;

@:using(stx.run.pack.uio.Implementation)
@:forward abstract UIO<T>(UIODef<T>) from UIODef<T> to UIODef<T>{
  static public inline function _() return stx.run.pack.uio.Constructor.ZERO;
  
  static public function fromFuture<T>(future:Future<T>):UIO<T>                  return _().fromFuture(future);
  static public function fromThunk<T>(thunk:Thunk<T>):UIO<T>                     return _().fromThunk(thunk);
  static public function fromReceiverDef<T>(fn:(T->Void)->Automation):UIO<T>     return _().fromReceiverDef(fn);

  static public function feed<T>(handler:(T->Void)->Automation):UIO<T>           return _().feed(handler);
  static public function into<T>(handler:(T->Void)->Void):UIO<T>                 return _().into(handler);

  @:to public function toIO():IO<T,Dynamic>{
    return IO.fromUIOT(this);
  }
}