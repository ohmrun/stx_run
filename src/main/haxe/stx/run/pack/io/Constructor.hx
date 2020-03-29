package stx.run.pack.io;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();
  
  public inline function pure<O>(v:O):IO<O,Noise>{
    return fromFunXR(() -> v);
  }
  public function feed<O,E>(handler:(Res<O,E>->Void)->Automation):IO<O,E>{
    return Recall.Anon(
      (auto:Automation,cont:Res<O,E>->Void) -> {
        return auto.snoc(handler(cont));
      }
    );
  }
  public function call<O,E>(handler:(Res<O,E>->Void)->Void):IO<O,E>{
    return feed( 
      (cb:Res<O,E>->Void) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  public inline function fromUIODef<T>(fn:Recall<Automation,T,Automation>):IO<T,Dynamic>{
    return Recall.Anon(
      (auto:Automation,cb:Res<T,Dynamic>->Void) -> fn.applyII(auto,
        (t:T) -> cb(__.success(t))
      )
    );
  }
  public inline function fromIODef<O,E>(fn:Automation->(Res<O,E>->Void)->Automation):IO<O,E>{
    return Recall.Anon(
      (auto,cb) -> fn(auto,cb)
    );
  }
  public inline function fromFunXRes<R,E>(chk:Void -> Res<R,E>):IO<R,E>{
    return call((handler) -> handler(chk()));
  }
  public inline function fromRes<R,E>(chk:Res<R,E>):IO<R,E>{
    return fromFunXRes(()->chk);
  }

  public inline function fromFunXR<R>(thk:Void -> R):IO<R,Noise>{
    return fromFunXRes(
      () -> __.success(thk())
    );
  }
  public inline function fromFun1R<R,E>(fn:Noise -> Res<R,E>):IO<R,E>{
    return fromFunXRes(fn.bind(Noise));
  }
  public inline function fromFunXIO<R,E>(fn:Unary<Noise,IO<R,E>>):IO<R,E>{
    return feed((handler) -> fn(Noise).applyII(Automation.unit(),handler));
  }
  public inline function bind_fold<A,E,R>(fn:A->R->IO<R,E>,arr:Array<A>,r:R):IO<R,E>{
    return arr.lfold(
      (next,memo:IODef<R,E>) -> return memo.fmap((r:R) -> fn(next,r)),
      fromRes(__.success(r))
    );
  }
}