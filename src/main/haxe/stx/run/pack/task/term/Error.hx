package stx.run.pack.task.term;

class Error<E> extends Base{
  var error : Err<AutomationFailure<E>>;
  public function new(error:Err<AutomationFailure<E>>){
    super();
    this.error = error;
  }
  override public function do_pursue(){
    this.progress = Progression.pure(Problem(error));
    return false;
  }
}