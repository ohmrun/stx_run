package stx.run.pack.task.term;

class When<T> extends Base{
  var trigger   : FutureTrigger<T>;

  public function new(?trigger){
    super();
    this.trigger  = trigger == null ? Future.trigger() : trigger;
    this.progression(Waiting(this.trigger.map(_ -> Noise)));

    this.trigger.handle(
      (_) -> {
        this.progression(Secured);
      }
    );
  }
  override private function do_pursue():Bool{
    return switch(this.progress.data){
      case Secured | Escaped | Problem(_)  : false;
      default : true;
    }
  }
  override public function toString(){
    return 'On(${this.progress.data})';
  }
}