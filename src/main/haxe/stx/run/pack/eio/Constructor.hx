package stx.run.pack.eio;

import stx.run.pack.eio.Typedef in EIOT;

@:allow(stx) class Constructor{
  private function new(){}
  public var _(default,null)  = new Destructure();

  public function lift<E>(eio:EIOT<E>):EIO<E> return new EIO(eio);

  public function fromOptionThunk<E>(thk:Thunk<Option<TypedError<E>>>):EIO<E>{
    return lift(Recall.inj.fromThunk(thk.then(Report.lift).prj()));
  }
  public function fromThunk<E>(thk:Thunk<Report<E>>):EIO<E>{
    return lift(Recall.inj.fromThunk(thk.prj()));
  }
  public function pure<E>(report:Report<E>):EIO<E>{
    return fromThunk(() -> report);
  }
  public function unit<E>():EIO<E>{
    return pure(Report.unit());
  }
  
  public function bfold<T,E>(fn:T->Report<E>->EIO<E>,arr:Array<T>):EIO<E>{
    return arr.lfold(
      (next:T,memo:EIO<E>) -> EIO.lift(memo.toUIO().fmap(
        (report) -> fn(next,report).toUIO()
      ).prj()),
      unit()
    );
  }
}