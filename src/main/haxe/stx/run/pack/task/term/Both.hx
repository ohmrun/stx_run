package stx.run.pack.task.term;

class Both extends Base{
  var init : Bool = false;
  var lhs  : Task;
  var rhs  : Task;
  public function new(lhs,rhs){
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function do_pursue(){
    var recurring = true;
  
    if(
      lhs.
    )
    if(arr.all(
      (x) -> switch(x.progress.data){
        case Pending  : true;
        default       : false;
      }
    )){
      recurring = true;
    }
    if(arr.any(
      (x) -> switch(x.progress.data){
        case Problem(_) | Pending : true;
        default                   : false;
      }
    )){
      recurring = false;
      this.escape();
    }
    return recurring;
  }
}