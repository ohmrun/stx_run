package stx.run.pack.schedule.term;

class Anon extends Base{
  var delegate : Void->Tick;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function reply(){
    //trace('anon');
    return delegate();
  }
}