package stx.run.pack.io;

import stx.run.pack.io.Typedef in IOT;

@:allow(stx) class Constructor{
  private function new(){}

  public var _(default,null) = new Destructure();
  
  public inline function lift<R,E>(io:IOT<R,E>){
    return new IO(io);
  }
  public inline function pure<R>(v:R):IO<R,Noise>{
    return fromThunk(() -> v);
  }
  public function feed<T>(handler:(T->Void)->Automation){
    return lift(Recall.inj.lift(
      (auto,cont) -> {
        return auto.concat(handler(cont));
      }
    ));
  }
  public function call<T>(handler:(T->Void)->Void){
    return feed(handler.fn().returning(Automation.unit()));
  }
  public inline function fromUIOT<O>(fn:Recall<Automation,O,Automation>):IO<O,Noise>{
    return feed((handler) -> fn(Noise,
      (o) -> handler(Right(o))
    ));
  }
  public inline function fromIOT<O,E>(fn:Automation->((Outcome<O,E>->Void)->Automation)):IO<O,E>{
    return lift(Recall.inj.lift(fn));
  }
  public inline function fromOutcomeThunk<R,E>(chk:Thunk<Outcome<R,E>>):IO<R,E>{
    return call((handler) -> handler(chk()));
  }
  public inline function fromOutcome<R,E>(chk:Outcome<R,E>):IO<R,E>{
    return fromOutcomeThunk(()->chk);
  }
  public inline function fromThunk<R>(thk:Thunk<R>):IO<R,Noise>{
    return fromOutcomeThunk(thk.then(Right).then(Outcome.lift));
  }

  public inline function bfold<A,E,R>(fn:A->R->IO<R,E>,arr:Array<A>,r:R):IO<R,E>{
    return arr.lfold(
      (next,memo:IO<R,E>) -> return memo.fmap((r:R) -> fn(next,r)),
      fromOutcome(Right(r))
    );
  }
  public inline function fromUnary<E,R>(fn:Unary<Noise,Outcome<R,E>>):IO<R,E>{
    return fromOutcomeThunk(fn.bind1(Noise));
  }
  public inline function fromUnaryConstructor<E,R>(fn:Unary<Noise,IO<R,E>>):IO<R,E>{
    return feed((handler) -> fn(Noise)(Automation.unit(),handler));
  }
}