package stx.run.pack.uio;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,null) = new Destructure();
  
  public function feed<T>(handler:(T->Void)->Automation):UIO<T>{
    return Recall.Anon((auto:Automation,cb:T->Void) -> auto.snoc(handler(cb)));
  }
  public function into<T>(handler:(T->Void)->Void):UIO<T>{
    return feed(
      (cb) -> { handler(cb); return Automation.unit(); }
    );
  }
  public function fromFuture<T>(v:Future<T>):UIO<T>{
    return Receiver.fromFuture(v).toUIO();
  }
  public function fromThunk<T>(v:Thunk<T>):UIO<T>{
    return into((cb) -> cb(v()));
  }
  public function fromReceiverDef<T>(fn:(T->Void)->Automation):UIO<T>{
    return feed((cb) -> fn(cb));
  }
}