package stx.run.pack;

import stx.run.head.data.Waiter in WaiterT;
import stx.run.head.data.IO     in IOT;
import stx.run.head.IOs;

@:callable @:forward abstract IO<R,E>(IOT<R,E>){
  public function new(self:IOT<R,E>) this = self;
  @:noUsing static public function pure<R>(v:R):IO<R,Noise>                                         return IOs.pure(v);
  @:noUsing static public function lift<R,E>(th:IOT<R,E>):IO<R,E>                                   return new IO(th);
  @:noUsing static public function fromUIOT<O>(fn:Automation->((O->Void)->Automation)):IO<O,Noise>  return IOs.fromUIOT(fn);
  

  public function map<Z>(fn:R->Z):IO<Z,E>                                     return IOs._.map(fn,self);
  public function fmap<Z>(fn:R->IO<Z,E>):IO<Z,E>                              return IOs._.fmap(fn,self);
  public function fold<Z>(v:R->Z,e:Null<TypedError<E>>->Z,n:Thunk<Z>):UIO<Z>  return IOs._.fold(v,e,n,self);
  public function zip<P,Z>(that:IO<P,E>,fn:R->P->Z):IO<Z,E>                   return IOs._.zip(fn,that,self); 
  
  public function then<O>(arw:Channel<R,O,E>):Proceed<O,E>{
    return Proceeds.fromIO(self).then(arw);
  }
  public function export<I,O>(fn:R->Channel<I,O,E>):Channel<I,O,E>{
    return Channel.lift(
      __.arw().cont()(
        (chunk:Chunk<I,E>,contN:Continue<Chunk<O,E>>) -> {
          var trigger = Future.trigger();
          return Automations.later(
            Receiver.lift((cont1:Automation -> Void) -> {
              return this(Automation.unit())(
                (r_data:Chunk<R,E>) -> {
                  switch(r_data){
                    case Val(v) : cont1(fn(v).prepare(chunk,contN));
                    case End(e) : cont1(contN(End(e),Automation.unit()));
                    case Tap    : cont1(contN(Tap,Automation.unit()));
                  }
                }
              );
            })
          );
        }
      )
    );
  }
  public function errata<E0>(fn:TypedError<E>->TypedError<E0>):IO<R,E0>{
    return new IO(this.then(
      (wtr) -> Waiter.lift(wtr).errata(fn).prj()
    ));
  }
  public function deliver(fn:Chunk<R,E>->Void):Automation{
    return Automations.later(
      Receiver.lift((next) -> { 
        return this(Automations.unit())(
          (chk) -> {
            fn(chk);
          }
        );
      })
    );
  }
  public function point(fn:R->EIO<E>):EIO<E>{
    return fmap(fn.fn().then(_ -> _.toIO())).fold(
      (_) -> None,
      (e) -> Some(e),
      ()  -> None
    ).toEIO();
  }












 
  public function elide():IO<Any,E>{
    return lift(function(auto):Receiver<Chunk<Any,E>>{
      return Receiver.lift(Waiter.lift(this(auto)).map(
        (v) -> ((cast v):Any)
      ).prj());
    });
  }
  public function prj():IOT<R,E>{
    return this;
  }
  private var self(get,never):IO<R,E>;
  private function get_self():IO<R,E> return lift(this);
  // public function now():Chunk<R,E>{
  //   return this(None).now();
  // }
  // public function force(?pos:haxe.PosInfos):R{
  //   return now().force(pos);
  // }

}