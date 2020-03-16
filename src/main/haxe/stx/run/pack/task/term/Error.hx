package stx.run.pack.task.term;

class Error extends Base{
  var error : TypedError<AutomationFailure<Dynamic>>;
  public function new(error){
    super();
    this.error = error;
  }
  override public function do_pursue(){
    this.progress = Progression.pure(Problem(error));
    return false;
  }
}