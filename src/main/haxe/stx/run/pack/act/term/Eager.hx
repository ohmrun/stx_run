package stx.run.pack.act.term;

class Eager extends Base{
  override public function upply(thk){
    thk();
  }
}