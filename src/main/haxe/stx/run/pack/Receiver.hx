package stx.run.pack;

@:using(stx.run.pack.io.Implementation)
@:forward abstract Receiver<T>(ReceiverDef<T>) from ReceiverDef<T> to ReceiverDef<T>{
  static public inline function _() return stx.run.pack.receiver.Constructor.ZERO;

  static public function fromFuture<T>(ft:Future<T>):Receiver<T>         return _().fromFuture(ft);
  static public function fromThunk<T>(thk:Thunk<T>):Receiver<T>          return _().fromThunk(thk);
  static public function fromReactor<T>(rct:ReactorDef<T>):Receiver<T>   return _().fromReactor(rct);

  static public function into<T>(handler:(T->Void)->Void):Receiver<T>    return _().into(handler);
  static public function feed<T>(cb:(T->Void)->Automation):Receiver<T>   return _().feed(cb);
  static public function pure<T>(t:T):Receiver<T>                        return _().pure(t);
}