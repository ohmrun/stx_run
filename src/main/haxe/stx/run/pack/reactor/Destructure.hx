package stx.run.pack.reactor;

class Destructure extends Clazz{
  public function or<T>(that:ReactorDef<T>,self:ReactorDef<T>){
    return Reactor.inj().into(
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
  public function fmap<T,TT>(fn:T->ReactorDef<TT>,self:ReactorDef<T>):ReactorDef<TT>{
    return Reactor.inj().into(
      (cb:TT->Void) -> self.upply(
        (t:T) -> fn(t).upply(cb)
      )
    );
  }
  public function map<T,TT>(fn:T->TT,self:ReactorDef<T>):ReactorDef<TT>{
    return Reactor.inj().into(
      (cbTT) -> self.upply(
        (t) -> cbTT(fn(t))
      )
    );
  }
  public function toReceiver<T>(self:ReactorDef<T>):ReceiverDef<T>{
    return Receiver.inj().into((cont) -> {
      return Task.inj().pursue(self.duoply.bind(Noise,cont));
    });
  }
  public function upply<T>(cb:T->Void,self:ReactorDef<T>):Void{
    self.prj().duoply(Noise,cb);
  }
}