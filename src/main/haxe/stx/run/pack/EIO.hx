package stx.run.pack;

import stx.run.head.data.EIO in EIOT;

@:callable abstract EIO<E>(EIOT<E>) from EIOT<E> {
  public function new(self){
    this = self;
  }
  @:noUsing static public function lift<E>(eio:EIOT<E>):EIO<E>{
    return new EIO(eio);
  }
  public function fold<Z>(pure:TypedError<E>->Z,zero:Thunk<Z>):UIO<Z>{
    return UIO.lift((auto) -> (cb:Z->Void) ->
      this(auto)(
        Options._.fold.bind(pure,zero.prj())
          .broker(
            F -> F.then(_ -> _.fn().then(__.command(cb)))
          )
      ));
  }
  @:from static public function fromThunk<E>(thk:Thunk<Option<TypedError<E>>>):EIO<E>{
    return (wrk) -> __.of(thk()).receive();
  }
  @:from static public function fromThunkEIO<E>(thk:Thunk<EIO<E>>):EIO<E>{
    return (wrk) -> thk()(wrk);
  }
  public function mod<EE>(fn:Option<TypedError<E>>->Option<TypedError<EE>>):EIO<EE>{
    return (wrk) -> Receiver.lift(this(wrk)).map(fn).prj();
  }
  public function toIO():IO<Noise,E>{
    return IOs.fromIOT(lift(this).fold(
      (err) -> End(err),
      ()    -> Val(Noise)
    ));
  }
  public function errata<EE>(fn:TypedError<E>->TypedError<EE>):EIO<EE>{
    return mod(
      (opt:Option<TypedError<E>>) -> opt.map(fn)
    );
  }
  public function toUIO():UIO<Option<TypedError<E>>>{
    return UIOs.lift(this);
  }
  public function prj():EIOT<E>{
    return this;
  }
  public function crunch(){
    return Receiver.lift(this(Automation.unit()))(
      opt -> switch(opt){
        case Some(v) : throw(v);
        default      : 
      }
    ).crunch();
  }
}