package stx.run.pack;

import stx.run.pack.reactor.Typedef in ReactorT;

@:allow(stx) @:forward @:callable abstract Reactor<T>(ReactorT<T>) to ReactorT<T>{
  private function new(self) this = self;
  static public var inj(default,null) = new Constructor();

  @:noUsing static inline private function lift<T>(obs:ReactorT<T>):Reactor<T>  return inj.lift(obs);

  @:noUsing static public function pure<T>(v:T):Reactor<T>              return inj.pure(v);
  @:noUsing static public function unit<T>():Reactor<T>                 return inj.unit();

  public inline function map<U>(fn:T->U):Reactor<U>{
    return lift((cb:U->Void) -> this((t:T) -> cb(fn(t))));
  }

  public function prj():ReactorT<T> return this; 
  
  public function toReceiver():Receiver<T>{
    return Receiver.lift((cont) -> {
      return Task.inj.pursue(this.bind(cont));
    });
  }
  public function or(that)      return inj._.or(that,self);
  public function fmap(fn)      return inj._.fmap(fn,self);

  private var self(get,never):Reactor<T>;
  private function get_self():Reactor<T> return lift(this);
}
private abstract Never<T>(Reactor<T>) to Reactor<T>{
  private function new(){
    this = Reactor.lift(method);
  }
  private static function method<T>(_:Noise,cont:T->Void):Void{

  }
  static public function unit(){
    return new Never();
  }
  public function toReactor():Reactor<T>{
    return this;
  }
}
private class Pure<T>{
  var data : T;
  public function new(data){
    this.data = data;
  }
  private function biuply(_:Noise,cont:T->Void):Void{
    cont(data);
  }
  public inline function toReactor(){
    return Reactor.lift(biuply);
  }
}
private class Constructor{
  public var _ = new Destructure();
  public function new(){}
  //aka never
  public function unit<T>():Reactor<T>{
    return new Never();
  }
  public inline function pure<T>(v:T):Reactor<T>{
    return new Pure(v).toReactor();
  }
  public inline function call<T>(cb:(T->Void) -> Void):Reactor<T>{
    return lift(
      (_:Noise,cont:T->Void) -> cb(cont)
    );
  }
  public function lift<T>(obs:ReactorT<T>):Reactor<T>{
    return new Reactor(obs);
  }
  public function bind_fold<T,R>(arr:Array<T>,fn:T->R->Reactor<R>,init:R):Reactor<R>{
    return arr.lfold(
      (next:T,memo:Reactor<R>) -> memo.fmap(
        (r) -> fn(next,r)
      ),
      pure(init)
    );
  }
  public function any<T>(arr:Array<Reactor<T>>):Option<Reactor<T>>{
    return arr.lfold1(_.or);
  }
  public function fromNoiseThunk<T>(fn:Noise->T):Reactor<T>{
    return lift(call((cont) -> cont(fn(Noise))));
  }
  public function fromThunk<T>(fn:Void->T):Reactor<T>{
    return lift(call((cont) -> cont(fn())));
  }
}
private class Destructure extends Clazz{
  public function or<T>(that:Reactor<T>,self:Reactor<T>){
    return Reactor.lift(
      Recall.call(
        (cb) -> {
          var done    = false;
          var uber_cb = (t:T) -> {
            if(!done){
              done = true;
              cb(t);
            }
          }
          self(uber_cb);
          that(uber_cb);
        } 
      )
    );
  }
  public function fmap<T,U>(fn:T->Reactor<U>,self:Reactor<T>):Reactor<U>{
    return Recall.inj._.fmap(
      fn.fn().then((rct) -> rct.prj()),
      self.prj()
    );
  }
}