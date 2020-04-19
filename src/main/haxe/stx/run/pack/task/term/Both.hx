package stx.run.pack.task.term;

class Both extends Base{
  var init : Bool = false;

  var lhs  : Task;
  var rhs  : Task;
  
  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override private function do_pursue(){
    if(!init){
      init = true;
      lhs.pursue();
      rhs.pursue();
    }
    return lhs.progress.error().merge(rhs.progress.error()).map(
      e -> {
        progression(Problem(e));
        lhs.escape();
        rhs.escape();
        return false;
    }).def(
      () -> switch([lhs.progress.data,rhs.progress.data]){
        case [Polling(l),Polling(r)] :
          var t = l < r ? l : r;
          progression(Polling(t));
          return true;
        default :
          this.progression(
            lhs.progress.is_less_than(rhs.progress) ? rhs.progress.data : lhs.progress.data
          );
          return progress.ongoing;
      }
    );
  }
}