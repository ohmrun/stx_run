package stx.run.pack.waiter;

class Destructure extends Clazz{
  
  public function map<T,TT,E>(fn:T->TT,self:Waiter<T,E>):Waiter<TT,E>{
    return Waiter.feed(
      (cb:Outcome<TT,E>->Void) -> self.duoply(Noise,
        (oc:Outcome<T,E>) -> cb(oc.map(fn))
      ) 
    );
  }
  public function fmap<T,TT,E>(fn:T->Waiter<TT,E>,self:Waiter<T,E>):Waiter<TT,E>{
    return Recall.Anon(
      (_:Noise,cb:Outcome<TT,E>->Void) -> self.duoply(Noise,
        (ocT:Outcome<T,E>) -> ocT.fold(
          (t) -> fn(t).duoply(Noise,cb),
          (e) -> {
            cb(__.failure(e));
            return Automation.unit();
          }
        )
      )
    );
  }
  public function fold<R,E,Z>(val:R->Z,err:TypedError<E>->Z,self:Waiter<R,E>):Receiver<Z>{
    return __._(Receiver._).map(
      Outcome.inj._.fold.bind(val,err),
      self.toReceiver()
    );
  }
  public function errata<R,E,E0>(fn:TypedError<E>->TypedError<E0>,self:Waiter<R,E>):Waiter<R,E0>{
    return Waiter.fromReceiverOutcome(__._(Receiver._).map(
      (oc:Outcome<R,E>) -> oc.errata(fn),
      self.toReceiver()
    ));
  }
}