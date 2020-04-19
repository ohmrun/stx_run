package stx.run.pack;

@:using(stx.run.pack.EIO.EIOLift)
@:forward abstract EIO<E>(EIODef<E>) from EIODef<E> to EIODef<E>{
  static public var _(default,never) = EIOLift;

  static public function lift<E>(self:EIODef<E>):EIO<E>                              return self;
  static public function feed<E>(fn:Automation->(Report<E>->Void)->Automation){
    return Recall.Anon(
      (auto:Automation,cb:Report<E>->Void) -> fn(auto,cb)
    );
  }
  static public function pass<E>(handler:(Report<E>->Void)->Automation){
    return feed(
      (auto,cb) -> auto.snoc(Task.Anon(handler.bind(cb)))
    );
  }
  static public function into<E>(handler:(Report<E>->Void)->Void){
    return pass(
      (cb:Report<E>->Void) -> {
        
        handler(cb);
        return Automation.unit();
      }
    );
  }
  static public function fromOptionThunk<E>(thk:Thunk<Option<Err<E>>>):EIO<E>{
    return fromThunk(thk.then(_ -> new Report(_)) );
  }
  static public function fromThunk<E>(thk:Thunk<Report<E>>):EIO<E>{
    return into((handler) -> handler(thk()));
  }
  static public function fromOption<E>(opt:Option<Err<E>>):EIO<E>{
    return fromOptionThunk(()->opt);
  }
  static public function pure<E>(report:Report<E>):EIO<E>{
    return fromThunk(() -> report);
  }
  static public function unit<E>():EIO<E>{
    return pure(Report.unit());
  }
  
  static public function bind_fold<T,E>(fn:T->Report<E>->EIO<E>,arr:Array<T>):EIO<E>{
    return arr.lfold(
      (next:T,memo:EIO<E>) -> EIO.lift(UIO._.flat_map(
        memo,
        (report) -> fn(next,report)
      )),
      unit()
    );
  }
  @:to public function toUIO():UIO<Report<E>>{
    return this;
  }
} 
class EIOLift{
  static public function fold<E,Z>(self:EIO<E>,pure:Err<E>->Z,zero:Thunk<Z>):UIO<Z>{
    return toUIO(self).map((report) -> report.prj().fold(pure,zero.prj()));
  }
  static public function mod<E,EE>(self:EIO<E>,fn:Report<E>->Report<EE>):EIO<EE>{
    return EIO.lift(UIO._.map(self,fn));
  }
  static public function toIO<E>(self:EIO<E>):IODef<Noise,E>{
    var a = self.fold(
      (err:Err<E>)  -> __.failure(err),
      ()            -> __.success(Noise)
    );
    return a.asRecallDef();
  }
  static public function errata<E,EE>(self:EIO<E>,fn:Err<E>->Err<EE>):EIO<EE>{
    return mod(self,(opt:Report<E>) -> opt.errata(fn));
  }
  static public function toUIO<E>(self:EIO<E>):UIO<Report<E>>{
    return self;
  }
}