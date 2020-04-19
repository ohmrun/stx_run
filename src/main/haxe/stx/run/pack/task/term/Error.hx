package stx.run.pack.task.term;

class Error<E> extends Base{
  var error : E;
  public function new(error:E){
    super();
    this.error = error;
  }
  override private function do_pursue(){
    this.progress = Progression.pure(Problem(__.fault().of(E_UnknownAutomation(error))));
    return false;
  }
}