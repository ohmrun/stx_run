package stx.run.pack.recall.term;

class Anon<I,O,R> extends Base<I,O,R>{
  var _applyII : RecallFun<I,O,R>;
  var done    : Bool;
  var res     : R;
  public function new(_applyII){
    super();
    this._applyII  = _applyII;
    this.done     = false;
  }
  override public function applyII(i:I,cont:O->Void):R{
    return if(!done){
      done = true;//HMMM
      res = _applyII(i,cont);
    }else{
      res;
    }
  }
}