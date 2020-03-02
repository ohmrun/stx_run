package stx.run.pack.recall.term;

class Pure<I,O,R> extends stx.run.pack.recall.term.Base<I,O,R>{
  var data : O;
  public function new(data:O){
    super();
    this.data = data;
  }
  override public function duoply(_:I,cont:O->Void):R{
    cont(data);
    return null;
  }
}