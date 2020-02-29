package stx.run.pack;

import stx.run.pack.io.Typedef     in IOT;

@:callable @:forward abstract IO<R,E>(IOT<R,E>){
  static public var inj(default,null)= new stx.run.pack.io.Constructor();


  public function new(self:IOT<R,E>) this = self;
  @:noUsing static public function pure<R>(v:R):IO<R,Noise>                                         return inj.pure(v);
  @:noUsing static public function lift<R,E>(th:IOT<R,E>):IO<R,E>                                   return new IO(th);
  @:noUsing static public function fromUIOT<O>(fn:Automation->((O->Void)->Automation)):IO<O,Noise>  return inj.fromUIOT(fn);
  

  public function map<Z>(fn:R->Z):IO<Z,E>                                     return inj._.map(fn,self);
  public function fmap<Z>(fn:R->IO<Z,E>):IO<Z,E>                              return inj._.fmap(fn,self);
  public function fold<Z>(v:R->Z,e:Null<TypedError<E>>->Z):UIO<Z>             return inj._.fold(v,e,self);
  public function zip<P,Z>(that:IO<P,E>,fn:R->P->Z):IO<Z,E>                   return inj._.zip(fn,that,self); 
  
  //public function then<O>(arw:Channel<R,O,E>):Proceed<O,E>{
    //return Proceeds.fromIO(self).then(arw);
  //}
  //public function export<I,O>(fn:R->Channel<I,O,E>):Channel<I,O,E>            return inj._.export(fn,self);
  public function errata<E0>(fn:TypedError<E>->TypedError<E0>):IO<R,E0>{
    return new IO(this.then(
      (wtr) -> wtr.errata(fn)
    ));
  }
  public function deliver(fn:Outcome<R,E>->Void):Automation{
    return Automation.inj.interim(
      Receiver.lift((next) -> this(Automation.unit())(
        (chk) -> fn(chk)
      ))
    );
  }
  public function wait(?auto:Automation):Waiter<R,E>{
    auto = __.option(auto).def(Automation.unit);
    return this(auto);
  }
  public function point(fn:R->EIO<E>):EIO<E>{
    return fmap(
      fn.fn().then(_ -> _.toIO())
    ).fold(
      (_) -> new Report(None),
      (e) -> new Report(Some(e))
    ).toEIO();
  }












 
  public function elide():IO<Any,E>{
    return lift(
      (auto) -> this(auto).map(
        (v) -> ((cast v):Any)
      )
    );
  }
  public function prj():IOT<R,E>{
    return this;
  }
  private var self(get,never):IO<R,E>;
  private function get_self():IO<R,E> return lift(this);
}
