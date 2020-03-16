package stx.run.pack.task.term;

import stx.ds.alias.StdArray;

class Seq extends Base{
  var gen : Void->Option<Task>;
  var arr : StdArray<Task>;

  public function new(gen){
    this.gen = gen;
    this.arr = [];
    super();
  }
  override public function do_pursue(){
    var last = arr.ds().last();
    return last.fold(
      (task:Task) -> 
        task.ongoing.if_else(
          () -> {
            task.pursue();
            true;
          },
          () -> switch(task.progress.data){
            case Problem(e) : 
              progression(task.progress.data);
              false;
            case Escaped    : 
              this.escape();
              false;
            case Secured    :
              gen().fold(
                (next) -> {
                  arr.push(next);
                  true;
                },
                () -> {
                  progression(Secured);
                  false;
                }
              );
            default :
              true;
          }
        ),
        () -> gen().fold(
          (task) -> {
            arr.push(task);
            true;
          },
          () -> {
            progression(Secured);
            false;
          }
        )
    );
  }
  override public function do_escape(){
    
  }
  override public function do_cleanup(){
    this.gen = () -> None;
    this.arr = [];
  }
}