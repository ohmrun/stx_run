package stx.run.pack;

@:using(stx.run.pack.eio.Implementation)
@:forward abstract EIO<E>(EIODef<E>) from EIODef<E> to EIODef<E>{
  static public inline function _() return stx.run.pack.eio.Constructor.ZERO;

  static public function lift<E>(self:EIODef<E>):EIO<E>                              return self;
  static public function pure<E>(report:Report<E>):EIO<E>                            return _().pure(report);
  static public function unit<E>():EIO<E>                                            return _().unit();

  
  @:from static public function fromOptionThunk<E>(thk:Thunk<Option<Err<E>>>):EIO<E> return _().fromOptionThunk(thk);
  @:from static public function fromThunk<E>(thk:Thunk<Report<E>>):EIO<E>                   return _().fromThunk(thk);
  @:from static public function fromOption<E>(opt:Option<Err<E>>):EIO<E>             return _().fromOption(opt);
  
  static public function bind_fold<T,E>(fn:T->Report<E>->EIO<E>,arr:Array<T>):EIO<E>        return _().bind_fold(fn,arr);

  @:to public function toUIO():UIO<Report<E>>{
    return this;
  }
} 