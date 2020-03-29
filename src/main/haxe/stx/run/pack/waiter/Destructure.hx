package stx.run.pack.waiter;

class Destructure extends Clazz{
  
  public function map<T,TT,E>(fn:T->TT,self:Waiter<T,E>):Waiter<TT,E>{
    return Waiter.feed(
      (cb:Res<TT,E>->Void) -> self.applyII(Noise,
        (oc:Res<T,E>) -> cb(oc.map(fn))
      ) 
    );
  }
  public function fmap<T,TT,E>(fn:T->Waiter<TT,E>,self:Waiter<T,E>):Waiter<TT,E>{
    return Recall.Anon(
      (_:Noise,cb:Res<TT,E>->Void) -> self.applyII(Noise,
        (ocT:Res<T,E>) -> ocT.fold(
          (t) -> fn(t).applyII(Noise,cb),
          (e) -> {
            cb(__.failure(e));
            return Automation.unit();
          }
        )
      )
    );
  }
  public function fold<R,E,Z>(val:R->Z,err:Err<E>->Z,self:Waiter<R,E>):Receiver<Z>{
    return Receiver._.map(
      Outcome._.fold.bind(_,val,err),
      self.toReceiver()
    );
  }
  public function errata<R,E,E0>(fn:Err<E>->Err<E0>,self:Waiter<R,E>):Waiter<R,E0>{
    return Waiter.fromReceiverRes(Receiver._.map(
      (oc:Res<R,E>) -> oc.errata(fn),
      self.toReceiver()
    ));
  }
}