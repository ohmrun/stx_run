package stx.run.pack;

import stx.run.head.data.Receiver in ReceiverT;
import stx.run.head.data.Waiter   in WaiterT;

abstract Waiter<R,E>(WaiterT<R,E>){
  public function new(self) this = self;
  @:noUsing static inline public function lift<R,E>(v:WaiterT<R,E>) return new Waiter(v);
  
  @:noUsing static inline public function fromChunk<R,E>(chk:Chunk<R,E>):Waiter<R,E>{
    return lift((cb:Chunk<R,E>->Void) -> {
      //return __.run().task(cb.bind(chk));TODO
      cb(chk);
      return Automation.unit();
    });
  }
  @:noUsing static inline public function fromChunkReceiver<R,E>(rcv:ReceiverT<Chunk<R,E>>):Waiter<R,E>{
    return lift(rcv);
  }
  public function map<U>(fn:R->U):Waiter<U,E>{
    return lift(Receiver.lift(this).map((chk) -> chk.map(fn)));
  }
  public function fmap<U>(fn:R->Waiter<U,E>):Waiter<U,E>{
    var fold = Chunks._.fold.bind(
      (r) -> fn(r),
      (e) -> fromChunk(End(e)),
      ()  -> fromChunk(Tap)
    ).fn()
     .then(_ -> Receiver.lift(_.prj()));
    var self = Receiver.lift(this);
    var next = self.fmap(fold);
    return lift(next.prj());
  }
  public function fold<Z>(val:R->Z,err:Null<TypedError<E>>->Z,nil:Void->Z):Receiver<Z>{
    return Receiver.lift(this).map(Chunks._.fold.bind(val,err,nil));
  }
  public function errata<E0>(fn:TypedError<E>->TypedError<E0>):Waiter<R,E0>{
    return lift(Receiver.lift(this).map(
      (chk) -> chk.errata(fn)
    ));
  }
  public inline function prj():WaiterT<R,E> return this;
}