package stx.run.pack.eio;

import stx.run.type.Package.EIODef in EIODefT;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never)  = new Destructure();

  public function feed<E>(fn:Automation->(Report<E>->Void)->Automation){
    return Recall.anon(
      (auto:Automation,cb:Report<E>->Void) -> fn(auto,cb)
    );
  }
  public function pass<E>(handler:(Report<E>->Void)->Automation){
    return feed(
      (auto,cb) -> auto.concat(handler(cb))
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
  public function fromOptionThunk<E>(thk:Thunk<Option<TypedError<E>>>):EIODef<E>{
    return fromThunk(thk.then(_ -> new Report(_)) );
  }
  public function fromThunk<E>(thk:Thunk<Report<E>>):EIODef<E>{
    return into((handler) -> handler(thk()));
  }
  public function pure<E>(report:Report<E>):EIODef<E>{
    return fromThunk(() -> report);
  }
  public function unit<E>():EIODef<E>{
    return pure(Report.unit());
  }
  
  public function bfold<T,E>(fn:T->Report<E>->EIODef<E>,arr:Array<T>):EIODef<E>{
    return arr.lfold(
      (next:T,memo:EIODef<E>) -> UIO.inj()._.fmap(
        (report) -> fn(next,report),
        memo
      ),
      unit()
    );
  }
}