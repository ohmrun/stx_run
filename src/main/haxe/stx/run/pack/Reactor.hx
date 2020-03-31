package stx.run.pack;

import stx.run.pack.recall.term.Base;
import stx.run.pack.recall.term.*;

@:using(stx.run.pack.Reactor.ReactorLift)
@:forward abstract Reactor<T>(ReactorDef<T>) from ReactorDef<T> to ReactorDef<T>{
  static public var _(default,never) = ReactorLift;
  static public function unit<T>():Reactor<T>{
    return new Never().asRecallDef();
  }
  static public inline function pure<T>(v:T):Reactor<T>{
    return new Pure(v).asRecallDef();
  }
  static public inline function into<T>(cb:(T->Void) -> Void):Reactor<T>{
    return Reactor.Anon(
      (_:Noise,cont:T->Void) -> cb(cont)
    );
  }
  static public function bind_fold<T,R>(arr:Array<T>,fn:T->R->Reactor<R>,init:R):Reactor<R>{
    return arr.lfold(
      (next:T,memo:Reactor<R>) -> memo.flat_map(
        (r) -> fn(next,r)
      ),
      pure(init)
    );
  }
  static public function any<T>(arr:Array<Reactor<T>>):Option<Reactor<T>>{
    return arr.lfold1(_.or);
  }
  static public function fromNoiseThunk<T>(fn:Noise->T):Reactor<T>{
    return into((cont) -> cont(fn(Noise)));
  }
  static public function fromThunk<T>(fn:Void->T):Reactor<T>{
    return into((cont) -> cont(fn()));
  }
  static public function Anon<T>(fn:RecallFun<Noise,T,Void>):Reactor<T>{
    return new Anon(fn);
  }
}
class ReactorLift extends Clazz{
  static public function or<T>(self:Reactor<T>,that:Reactor<T>){
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
  static public function flat_map<T,TT>(self:Reactor<T>,fn:T->Reactor<TT>):Reactor<TT>{
    return Reactor.into(
      (cb:TT->Void) -> self.upply(
        (t:T) -> fn(t).upply(cb)
      )
    );
  }
  static public function map<T,TT>(self:Reactor<T>,fn:T->TT):Reactor<TT>{
    return Reactor.into(
      (cbTT) -> self.upply(
        (t) -> cbTT(fn(t))
      )
    );
  }
  static public function toReceiver<T>(self:Reactor<T>):Receiver<T>{
    return Receiver.feed((cont) -> {
      return Task.Anon(self.applyII.bind(Noise,cont));
    });
  }
  static public function upply<T>(self:Reactor<T>,cb:T->Void):Void{
    self.asRecallDef().applyII(Noise,cb);
  }
}