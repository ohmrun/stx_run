package stx.run.pack.reactor.term;

class Anon<T> extends stx.run.pack.recall.term.Base<Noise,T,Void>{
  private var _duoply : RecallFunction<Noise,T,Void>;
  private var done    : Bool;
  public function new(_duoply){
    super();
    this._duoply  = _duoply;
    this.done     = false;
  }
  override public function duoply(_:Noise,cb:T->Void):Void{
    if(!done){
      this.done = true;
      _duoply(_,cb);
    }
  } 
}