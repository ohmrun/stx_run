package stx.run.pack.eio;

@:allow(stx)class Destructure extends Clazz{
  public function fold<E,Z>(pure:TypedError<E>->Z,zero:Thunk<Z>,self:EIODef<E>):UIODef<Z>{
    return toUIO(self).map((report) -> report.prj().fold(pure,zero.prj()));
  }
  public function mod<E,EE>(fn:Report<E>->Report<EE>,self:EIODef<E>):EIODef<EE>{
    return UIO.inj()._.map(fn,self);
  }
  public function toIO<E>(self:EIODef<E>):IODef<Noise,E>{
    var a = self.fold(
      (err) -> __.failure(err),
      ()    -> __.success(Noise)
    );
    return a.prj();
  }
  public function errata<E,EE>(fn:TypedError<E>->TypedError<EE>,self:EIODef<E>):EIODef<EE>{
    return mod((opt:Report<E>) -> opt.errata(fn),self);
  }
  public function toUIO<E>(self:EIODef<E>):UIODef<Report<E>>{
    return self;
  }
  public function crunch<E>(self:EIODef<E>){
    self.duoply(
      Automation.unit(),
      opt -> switch(opt){
        case Some(v) : throw(v);
        default      : 
      }
    ).crunch();
  }
}