package stx.run.pack;

import stx.run.head.data.Receiver in ReceiverT;
import stx.run.head.data.UIO      in UIOT;

@:forward @:callable abstract UIO<R>(UIOT<R>) to UIOT<R>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(thiz:UIOT<T>):UIO<T>{
    return new UIO(thiz);
  }
  //TODO how to compose here?
  @:noUsing static public function fromReceiverT<T>(cb:(T->Void)->Automation):UIO<T>{
    return lift((auto:Automation) -> (next:T->Void) -> {
      var auto0 = cb(
        (v) -> next(v)
      );
      return auto;
    });
  }
  

  public function map<Z>(fn:R->Z):UIO<Z>{
    var a =  lift(
      (auto:Automation) -> 
        (cb:Z->Void) -> 
          this(auto)(
            (r:R) -> {
              var z = fn(r);
              cb(z);
              return auto;
            }
          )
    );
    return a;
  }
  public function fmap<Z>(fn:R->UIO<Z>):UIO<Z>{
    return lift(
      (auto:Automation) -> 
        (cb:Z->Void) ->
          this(auto)(
            (r) -> fn(r)(auto)(cb)
          )
    );
  }
  public function attempt<Z,E>(fn:R->Chunk<Z,E>):IO<Z,E>{
    return IO.lift(map(fn));
  }



  public function toIO<E>():IO<R,Noise>{
    return IO.fromUIOT(this); 
  }


  public function prj():UIOT<R>{
    return this;
  }
  public function command(cb:R->Void):UIO<R>{
    return map(
      __.command(cb)
    );
  }
}