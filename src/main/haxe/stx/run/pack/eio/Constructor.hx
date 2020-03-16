package stx.run.pack.eio;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never)  = new Destructure();

  public function feed<E>(fn:Automation->(Report<E>->Void)->Automation){
    return Recall.Anon(
      (auto:Automation,cb:Report<E>->Void) -> fn(auto,cb)
    );
  }
  public function pass<E>(handler:(Report<E>->Void)->Automation){
    return feed(
      (auto,cb) -> auto.snoc(handler(cb))
    );
  }
  public function into<E>(handler:(Report<E>->Void)->Void){
    return pass(
      (cb:Report<E>->Void) -> {
        
        handler(cb);
        return Automation.unit();
      }
    );
  }
  public function fromOptionThunk<E>(thk:Thunk<Option<TypedError<E>>>):EIO<E>{
    return fromThunk(thk.then(_ -> new Report(_)) );
  }
  public function fromThunk<E>(thk:Thunk<Report<E>>):EIO<E>{
    return into((handler) -> handler(thk()));
  }
  public function fromOption<E>(opt:Option<TypedError<E>>):EIO<E>{
    return fromOptionThunk(()->opt);
  }
  public function pure<E>(report:Report<E>):EIO<E>{
    return fromThunk(() -> report);
  }
  public function unit<E>():EIO<E>{
    return pure(Report.unit());
  }
  
  public function bind_fold<T,E>(fn:T->Report<E>->EIO<E>,arr:Array<T>):EIO<E>{
    return arr.lfold(
      (next:T,memo:EIO<E>) -> UIO._()._.fmap(
        (report) -> fn(next,report),
        memo
      ),
      unit()
    );
  }
}