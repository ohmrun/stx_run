package stx.run.pack.eio;

@:allow(stx)class Destructure extends Clazz{
  public function fold<E,Z>(pure:TypedError<E>->Z,zero:Thunk<Z>,self:EIO<E>):UIO<Z>{
    return toUIO(self).map((report) -> report.prj().fold(pure,zero.prj()));
  }
  public function mod<E,EE>(fn:Report<E>->Report<EE>,self:EIO<E>):EIO<EE>{
    return __._(UIO._).map(fn,self);
  }
  public function toIO<E>(self:EIO<E>):IODef<Noise,E>{
    var a = self.fold(
      (err) -> __.failure(err),
      ()    -> __.success(Noise)
    );
    return a.asRecallDef();
  }
  public function errata<E,EE>(fn:TypedError<E>->TypedError<EE>,self:EIO<E>):EIO<EE>{
    return mod((opt:Report<E>) -> opt.errata(fn),self);
  }
  public function toUIO<E>(self:EIO<E>):UIO<Report<E>>{
    return self;
  }
}