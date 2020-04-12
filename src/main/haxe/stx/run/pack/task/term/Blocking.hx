package stx.run.pack.task.term;

class Blocking extends Base{
  var blocking : Ref<Bool>;
  public function new(blocking){
    super();
    this.blocking = blocking;
  }
  override public function do_pursue(){
    return if(blocking.value == false){
      this.progress = Progression.pure(Secured);
      false;
    }else{
      true;
    }
  }
}