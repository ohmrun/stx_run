package stx.run.pack.task.term;

class When<T> extends Base{
  var trigger   : FutureTrigger<T>;
  var received  : Bool = false;

  function new(){
    super();
    this.trigger = Future.trigger();
    this.trigger.asFuture().handle(
      (o) -> {
        this.received = true;
      }
    );
  }
  override public function do_pursue():Bool{
    return !received;
  }
}