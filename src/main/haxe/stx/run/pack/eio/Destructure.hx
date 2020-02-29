package stx.run.pack.eio;

@:allow(stx)class Destructure extends Clazz{
  public function fold<E,Z>(pure:TypedError<E>->Z,zero:Thunk<Z>,self:EIO<E>):UIO<Z>{
    return toUIO(self).map((report) -> report.prj().fold(pure,zero.prj()));
  }
  public function mod<E,EE>(fn:Report<E>->Report<EE>,self:EIO<E>):EIO<EE>{
    return self.prj().map(fn).broker( F -> EIO.lift );
  }
  public function toIO<E>(self:EIO<E>):IO<Noise,E>{
    var a = self.fold(
      (err) -> __.failure(err),
      ()    -> __.success(Noise)
    );
    return IO.inj.lift(a.prj());
  }
  public function errata<E,EE>(fn:TypedError<E>->TypedError<EE>,self:EIO<E>):EIO<EE>{
    return mod((opt:Report<E>) -> opt.errata(fn),self);
  }
  public function toUIO<E>(self:EIO<E>):UIO<Report<E>>{
    return UIO.inj.lift(self.prj());
  }
  public function crunch<E>(self:EIO<E>){
    Recall.inj._.fulfill(
      Automation.unit()
    ).deliver(
      opt -> switch(opt){
        case Some(v) : throw(v);
        default      : 
      }
    )(Noise).crunch();
  }
}