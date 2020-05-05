package stx.run.pack.task.term;

class Both extends All{
  var lhs  : Task;
  var rhs  : Task;
  
  public function new(lhs,rhs){
    super([lhs,rhs]);
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function toString():String{
    return 'Both($lhs $rhs)';
  }
}