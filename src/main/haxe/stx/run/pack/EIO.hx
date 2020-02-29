package stx.run.pack;

import stx.run.pack.eio.Typedef in EIOT;

@:callable abstract EIO<E>(EIOT<E>) from EIOT<E> {
  static public var inj(default,null) = new stx.run.pack.eio.Constructor();

  public function new(self) this = self;

  @:noUsing static public function unit<E>():EIO<E>                                   return inj.unit();
  @:noUsing static public function pure<E>(report:Report<E>):EIO<E>                   return inj.pure(report);
  @:noUsing static public function lift<E>(eio:EIOT<E>):EIO<E>                        return inj.lift(eio);

  
  public function fold<Z>(pure:TypedError<E>->Z,zero:Thunk<Z>):UIO<Z>                 return inj._.fold(pure,zero,this);
  public function mod<EE>(fn:Report<E>->Report<EE>):EIO<EE>                           return inj._.mod(fn,this);
  public function errata<EE>(fn:TypedError<E>->TypedError<EE>):EIO<EE>                return inj._.errata(fn,this);

  public function crunch()                                                            return inj._.crunch(this);

  public function toIO():IO<Noise,E>                                                  return inj._.toIO(this);
  public function toUIO():UIO<Report<E>>                                              return inj._.toUIO(this);  

  public function prj():EIOT<E> return this;
  
  
}