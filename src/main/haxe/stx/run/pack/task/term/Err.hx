package stx.run.pack.task.term;

class Err<E> extends Base{
  var error : stx.core.pack.Err<E>;
  public function new(error:stx.core.pack.Err<E>){
    super();
    this.error = error;
  }
  override private function do_pursue(){
    this.progress = Progression.pure(Problem(__.fault().of(E_Automation(error))));
    return false;
  }
}