package stx.run.pack.act.term;

class Anon extends Base{
  var delegate : (Void->Void) -> Void;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function upply(thk){
    delegate(thk);
  }
}