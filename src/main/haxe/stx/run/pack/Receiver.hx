package stx.run.pack;

import stx.run.pack.receiver.Typedef in ReceiverT;

@:forward @:callable abstract Receiver<T>(ReceiverT<T>) to ReceiverT<T>{
  static public var inj(default,null) = new Constructor();
  
  public function new(self) this = self;

  static public function lift<T>(v:ReceiverT<T>):Receiver<T>    return new Receiver(v.fn().memo());
  
  public function fromReactor<T>(obs:Reactor<T>):Receiver<T>    return inj.fromReactor(obs);

  public function map<TT>(fn:T->TT):Receiver<TT>                return inj._.map(fn,self);
  public function fmap<TT>(fn:T->Receiver<TT>):Receiver<TT>     return inj._.fmap(fn,self); 
  public function toWaiter():Waiter<T,Dynamic>                  return inj._.toWaiter(self);

  public function prj():ReceiverT<T> return this;
  
  public function command(cmd:T->Void):Receiver<T> return map(__.command(cmd));
}
private class Constructor extends Clazz{
  public var _(default,never) : Destructure;
  public function call<T>(cb:(T->Void)->Void):Receiver<T>{
    return feed(cb.fn().returning(Automation.unit()));
  }
  public function feed<T>(cb:(T->Void)->Automation):Receiver<T>{
    return Recall.lift(
      (_:Noise,cont) -> {
        return cb(cont);
      }
    );
  }
  public function pure<T>(t:T):Receiver<T>{
    return call((cb) -> cb(t));
  }
  public function fromFuture<T>(ft:Future<T>):Receiver<T>{
    return feed(
      (cb) -> {
        var canceller = ft.handle(cb);
        return Task.inj.anon(null,canceller.cancel).toAutomation();
      }
    );
  }
  public function fromThunk<T>(thk:Thunk<T>):Receiver<T>{
    return call((cb) -> cn(thk()));
  }
  public function fromReactor<T>(obs:Reactor<T>):Receiver<T>{
    return call((cb) -> obs(Noise,cb));
  }
}
private class Destructure{
  public function toWaiter<T>(self:Receiver<T>):Waiter<T,Dynamic>{
    return Waiter.inj.fromReceiver(self);
  }

  public function map<T,TT>(fn:T->TT,self:Receiver<T>){
    return Receiver.inj.call(
      (cb) -> self(Noise,
        (t) -> cb(fn(t))  
      )
    );
  }
  //chomp_release_automation(Au));
  public function fmap<T,TT>(fn:T->Receiver<TT>,self:Receiver<T>){
    return Receiver.inj.call(
      (handler:(TT->Void)->Void) -> Interim(
          Reactor.inj.call(
            (automation_release) -> {
              var done        = false;
              var automation  = None;
              var automation1 = None.core();
              var automation2 = None.core();

              function gate(){
                automation = automation1.zip(automation2).map(__.into2((l,r) -> l.concat(r)));
                if(!done && automation.is_defined()){
                  done = true;
                  automation_release(automation.release());
                }
              }
              var automation1 = Some(self(_,
                (t:T) -> {
                  var rcv         = fn(t);
                  automation2 = Some(rcv(_,
                    (tt:TT) -> {
                      handler(
                        (fn_TT) -> {
                          fn__TT(tt);
                        } 
                      );
                    }
                  )); 
                  gate();
                } 
              ));
              gate();
            }
          )
        )
    );
  }
}