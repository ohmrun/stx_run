package stx.run.pack.recall.term;

class Anon<I,O,R> extends Base<I,O,R>{
  var _duoply : RecallFun<I,O,R>;
  var done    : Bool;
  var res     : R;
  public function new(_duoply){
    super();
    this._duoply  = _duoply;
    this.done     = false;
  }
  override public function duoply(i:I,cont:O->Void):R{
    return if(!done){
      done = true;//HMMM
      res = _duoply(i,cont);
    }else{
      res;
    }
  }
}