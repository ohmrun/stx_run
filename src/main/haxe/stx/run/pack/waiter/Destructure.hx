package stx.run.pack.waiter;

class Destructure extends Clazz{
  
  public function map<T,TT,E>(fn:T->TT,self:WaiterDef<T,E>):WaiterDef<TT,E>{
    return Waiter.inj().feed(
      (cb:Outcome<TT,E>->Void) -> self.duoply(Noise,
        (oc:Outcome<T,E>) -> cb(oc.map(fn))
      ) 
    );
  }
  public function fmap<T,TT,E>(fn:T->WaiterDef<TT,E>,self:WaiterDef<T,E>):WaiterDef<TT,E>{
    return Recall.anon(
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
  public function fold<R,E,Z>(val:R->Z,err:TypedError<E>->Z,self:WaiterDef<R,E>):ReceiverDef<Z>{
    return Receiver.inj()._.map(
      Outcome.inj._.fold.bind(val,err),
      self
    );
  }
  public function errata<R,E,E0>(fn:TypedError<E>->TypedError<E0>,self:WaiterDef<R,E>):WaiterDef<R,E0>{
    return Receiver.inj()._.map(
      (oc:Outcome<R,E>) -> oc.errata(fn),
      self
    );
  }
}