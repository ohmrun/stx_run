package stx.run.pack.reactor;

class Destructure extends Clazz{
  public function or<T>(that:Reactor<T>,self:Reactor<T>){
    return Reactor.into(
      (cb) -> {
        var done    = false;
        var uber_cb = (t:T) -> {
          if(!done){
            done = true;
            cb(t);
          }
        }
        self.upply(uber_cb);
        that.upply(uber_cb);
      } 
    );
  }
  public function fmap<T,TT>(fn:T->Reactor<TT>,self:Reactor<T>):Reactor<TT>{
    return Reactor.into(
      (cb:TT->Void) -> self.upply(
        (t:T) -> fn(t).upply(cb)
      )
    );
  }
  public function map<T,TT>(fn:T->TT,self:Reactor<T>):Reactor<TT>{
    return Reactor.into(
      (cbTT) -> self.upply(
        (t) -> cbTT(fn(t))
      )
    );
  }
  public function toReceiver<T>(self:Reactor<T>):Receiver<T>{
    return Receiver.feed((cont) -> {
      return Task.Anon(self.applyII.bind(Noise,cont));
    });
  }
  public function upply<T>(cb:T->Void,self:Reactor<T>):Void{
    self.asRecallDef().applyII(Noise,cb);
  }
}