package stx.run.pack.receiver;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never)           = new Destructure();
  
  public function into<T>(handler:(T->Void)->Void):Receiver<T>{
    return feed(
      (cb) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  public function feed<T>(cb:(T->Void)->Automation):Receiver<T>{
    return Recall.Anon(
      (_:Noise,cont:T->Void) -> {
        return cb(cont);
      }
    );
  }
  public function pure<T>(t:T):Receiver<T>{
    return into((cb) -> cb(t));
  }
  public function fromFuture<T>(ft:Future<T>):Receiver<T>{
    return feed(
      (cb) -> {
        var canceller = ft.handle(cb);
        return Task.Anon(null,canceller.cancel).toAutomation();
      }
    );
  }
  public function fromThunk<T>(thk:Thunk<T>):Receiver<T>{
    return into((cb) -> cb(thk()));
  }
  public function fromReactor<T>(rct:ReactorDef<T>):Receiver<T>{
    return into((cb) -> rct.upply(cb));
  }
}