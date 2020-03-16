package stx.run.pack;

@:using(stx.run.pack.eio.Implementation)
@:forward abstract EIO<E>(EIODef<E>) from EIODef<E> to EIODef<E>{
  static public inline function inj() return stx.run.pack.eio.Constructor.ZERO;

  @:to public function toUIO():UIO<Report<E>>{
    return this;
  }
} 