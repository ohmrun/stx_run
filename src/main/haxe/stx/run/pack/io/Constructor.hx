package stx.run.pack.io;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();
  
  public inline function pure<R>(v:R):IODef<R,Noise>{
    return fromThunk(() -> v);
  }
  public function feed<T,E>(handler:(Outcome<T,E>->Void)->Automation){
    return Recall.Anon(
      (auto:Automation,cont:Outcome<T,E>->Void) -> {
        return auto.snoc(handler(cont));
      }
    );
  }
  public function call<T,E>(handler:(Outcome<T,E>->Void)->Void){
    return feed( 
      (cb:Outcome<T,E>->Void) -> {
        handler(cb);
        return Automation.unit();
      }
    );
  }
  public inline function fromUIOT<T>(fn:Recall<Automation,T,Automation>):IODef<T,Dynamic>{
    return Recall.Anon(
      (auto:Automation,cb:Outcome<T,Dynamic>->Void) -> fn.duoply(auto,
        (t:T) -> cb(__.success(t))
      )
    );
  }
  public inline function fromIOT<O,E>(fn:Automation->(Outcome<O,E>->Void)->Automation):IODef<O,E>{
    return Recall.Anon(
      (auto,cb) -> fn(auto,cb)
    );
  }
  public inline function fromOutcomeThunk<R,E>(chk:Thunk<Outcome<R,E>>):IODef<R,E>{
    return call((handler) -> handler(chk()));
  }
  public inline function fromOutcome<R,E>(chk:Outcome<R,E>):IODef<R,E>{
    return fromOutcomeThunk(()->chk);
  }
  public inline function fromThunk<R>(thk:Thunk<R>):IODef<R,Noise>{
    return fromOutcomeThunk(thk.then(Right).then(Outcome.lift));
  }
  public inline function fromUnary<E,R>(fn:Unary<Noise,Outcome<R,E>>):IODef<R,E>{
    return fromOutcomeThunk(fn.bind1(Noise));
  }
  public inline function fromUnaryConstructor<E,R>(fn:Unary<Noise,IODef<R,E>>):IODef<R,E>{
    return feed((handler) -> fn(Noise).duoply(Automation.unit(),handler));
  }
  public inline function bfold<A,E,R>(fn:A->R->IODef<R,E>,arr:Array<A>,r:R):IODef<R,E>{
    return arr.lfold(
      (next,memo:IODef<R,E>) -> return memo.fmap((r:R) -> fn(next,r)),
      fromOutcome(Right(r))
    );
  }
}