package stx.run.pack.reactor.term;

class Anon<T> extends stx.run.pack.recall.term.Base<Noise,T,Void>{
  private var _applyII : RecallFun<Noise,T,Void>;
  private var done    : Bool;
  public function new(_applyII){
    super();
    this._applyII  = _applyII;
    this.done     = false;
  }
  override public function applyII(_:Noise,cb:T->Void):Void{
    if(!done){
      this.done = true;
      _applyII(_,cb);
    }
  } 
}