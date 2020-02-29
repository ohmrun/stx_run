package stx.run.pack;

import stx.run.pack.receiver.Typedef in ReceiverT;
import stx.run.pack.waiter.Typedef   in WaiterT;

@:callable abstract Waiter<R,E>(WaiterT<R,E>){
  public function new(self) this = self;
  static public var inj(default,null) = new Constructor();


  @:noUsing static inline public function lift<R,E>(v:WaiterT<R,E>)                   return inj.lift(v);  
  @:noUsing static inline public function fromOutcome<R,E>(chk:Outcome<R,E>):Waiter<R,E>  return inj.fromOutcome(chk);
  @:noUsing static inline public function fromOutcomeReceiver<R,E>(rcv:ReceiverT<Outcome<R,E>>):Waiter<R,E> return inj.fromOutcomeReceiver(rcv);
  
  public function map<U>(fn:R->U):Waiter<U,E>                                             return inj._.map(fn,self);
  public function fmap<U>(fn:R->Waiter<U,E>):Waiter<U,E>                                  return inj._.fmap(fn,self);
  public function fold<Z>(val:R->Z,err:Null<TypedError<E>>->Z):Receiver<Z>                return inj._.fold(val,err,self);
  public function errata<E0>(fn:TypedError<E>->TypedError<E0>):Waiter<R,E0>               return inj._.errata(fn,self);

  public inline function prj():WaiterT<R,E> return this;
  private var self(get,never):Waiter<R,E>;
  private function get_self():Waiter<R,E> return lift(this);
}
private class Constructor{
  public var _(default,null) = new Destructure();
  public function new(){}
  public function lift<R,E>(v:WaiterT<R,E>) return new Waiter(v);
  public function fromOutcome<R,E>(chk:Outcome<R,E>):Waiter<R,E>{
    __.log().close().trace('fromOutcome');
    return lift((cb:Outcome<R,E>->Void) -> {
      __.log().close().trace('inside');
      //return __.run().task(cb.bind(chk));TODO
      cb(chk);
      return Automation.unit();
    });
  }
  inline public function pure<R,E>(chk:Outcome<R,E>){
    return fromOutcome(chk);
  }
  public function fromOutcomeReceiver<R,E>(rcv:ReceiverT<Outcome<R,E>>):Waiter<R,E>{
    return lift(rcv);
  }
}
private class Destructure{
  public function new(){}
  public function map<R,E,U>(fn:R->U,self:Waiter<R,E>):Waiter<U,E>{
    return Waiter.lift(
      Receiver.lift(self.prj()).map((chk) -> chk.map(fn))
    );
      
  }
  public function fmap<R,E,U>(fn:R->Waiter<U,E>,self:Waiter<R,E>):Waiter<U,E>{
    var fold = Outcome.inj._.fold.bind(
      (r) -> fn(r),
      (e) -> Waiter.inj.fromOutcome(Left(e))
    ).fn()
     .then(_ -> Receiver.lift(_.prj()));
    var self = Receiver.lift(self.prj());
    var next = self.fmap(fold);
    return Waiter.lift(next.prj());
  }
  public function fold<R,E,Z>(val:R->Z,err:Null<TypedError<E>>->Z,self:Waiter<R,E>):Receiver<Z>{
    return Receiver.lift(self.prj()).map(Outcome.inj._.fold.bind(val,err));
  }
  public function errata<R,E,E0>(fn:TypedError<E>->TypedError<E0>,self:Waiter<R,E>):Waiter<R,E0>{
    return Waiter.lift(
      Receiver.lift(self.prj()).map((chk -> chk.errata(fn)))
    );
  }
}