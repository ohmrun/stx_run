package stx.run.pack;

import stx.run.pack.receiver.Typedef in ReceiverT;
import stx.run.pack.uio.Typedef      in UIOT;

@:forward @:callable abstract UIO<R>(UIOT<R>){
  static public var inj(default,null) = new Constructor();

  public function new(self:UIOT<R>) this = self;
  @:noUsing static public function lift<T>(thiz:UIOT<T>):UIO<T>                       return inj.lift(thiz);
  @:noUsing static public function fromReceiverT<T>(cb:(T->Void)->Automation):UIO<T>  return inj.fromReceiverT(cb);

  public function map<Z>(fn:R->Z):UIO<Z>                  return inj._.map(fn,self);
  public function fmap<Z>(fn:R->UIO<Z>):UIO<Z>            return inj._.fmap(fn,self);
  public function attempt<Z,E>(fn:R->Outcome<Z,E>):IO<Z,E>  return inj._.attempt(fn,self);
  public function command(cb:R->Void):UIO<R>              return inj._.command(cb,self);

  public function toIO<E>():IO<R,Noise>                   return IO.inj.fromUIOT(this); 

  public function prj():UIOT<R> return this;
  private var self(get,never):UIO<R>;
  private function get_self():UIO<R> return lift(this);

}

private class Constructor{
  public var _(default,null) = new Destructure();
  public function new(){}
  public function lift<T>(uio:UIOT<T>):UIO<T>{
    return new UIO(uio);
  }
  public function fromFuture<T>(v:Future<T>):UIO<T>{
    return UIO.lift(
      (auto) -> Receiver.lift(Receiver.inj.fromFuture(v))//TODO
    );
  }
  public function fromThunk<T>(v:Thunk<T>):UIO<T>{
    return UIO.lift(
      (auto) -> Receiver.inj.fromThunk(v)
    );
  }
  //TODO how to compose here?
  public function fromReceiverT<T>(cb:(T->Void)->Automation):UIO<T>{
    return lift((auto:Automation) -> Receiver.lift((next:T->Void) -> {
      var auto0 = cb(
        (v) -> next(v)
      );
      return auto;
    }));
  }
}
private class Destructure extends Clazz{
  public function lift<T>(self:UIOT<T>){
    return new UIO(self);
  }
  public function feed<T>(handler:(T->Void)->Automation){
    return lift((auto,cb) -> auto.concat(handler(cb)));
  }
  public function call<T>(handler:(T->Void)->Void){
    return feed(handler.fn().returning(Automation.unit()));
  }
  public function map<R,Z>(fn:R->Z,self:UIO<R>):UIO<Z>{
    return 
    var a =  UIO.lift(
      (auto:Automation) -> 
        Receiver.lift((cb:Z->Void) -> 
          self(auto)(
            (r:R) -> {
              var z = fn(r);
              cb(z);
              return auto;
            }
          ))
    );
    return a;
  }
  public function attempt<R,Z,E>(fn:R->Outcome<Z,E>,self:UIO<R>):IO<Z,E>{
    return IO.lift(map(fn,self).prj().then(Waiter.lift));
  }
  public function command<R>(cb:R->Void,self:UIO<R>):UIO<R>{
    return map(
      __.command(cb),
      self
    );
  }
}