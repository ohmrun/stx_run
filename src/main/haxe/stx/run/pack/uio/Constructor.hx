package stx.run.pack.uio;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,null) = new Destructure();
  
  public function feed<T>(handler:(T->Void)->Automation):UIODef<T>{
    return Recall.anon((auto:Automation,cb:T->Void) -> auto.concat(handler(cb)));
  }
  public function into<T>(handler:(T->Void)->Void):UIODef<T>{
    return feed(
      (cb) -> { handler(cb); return Automation.unit(); }
    );
  }
  public function fromFuture<T>(v:Future<T>):UIODef<T>{
    return Receiver.inj().fromFuture(v).toUIO();
  }
  public function fromThunk<T>(v:Thunk<T>):UIODef<T>{
    return UIO.inj().into((cb) -> cb(v()));
  }
  public function fromReceiverT<T>(fn:(T->Void)->Automation):UIODef<T>{
    return UIO.inj().feed((cb) -> fn(cb));
  }
}