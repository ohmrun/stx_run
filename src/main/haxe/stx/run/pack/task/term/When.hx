package stx.run.pack.task.term;

class When<T> extends Base{
  var trigger   : FutureTrigger<T>;
  var received  : Bool = false;

  public function new(?trigger){
    super();
    this.trigger  = trigger == null ? Future.trigger() : trigger;
    this.progression(
      Waiting(this.trigger.asFuture().map(
        (_) -> {
          this.received = true;
          return Noise;
        }
      ))
    );
  }
  override private function do_pursue():Bool{
    return if(received){
      progression(Secured);
      false;
    }else{
      true;
    }
  }
}