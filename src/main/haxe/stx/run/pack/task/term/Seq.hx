package stx.run.pack.task.term;

using Lambda;
import stx.core.alias.StdArray;

class Seq extends Base{
  var gen : Iterator<Task>;
  var arr : StdArray<Task>;

  public function new(gen){
    this.gen = gen;
    this.arr = [];
    super();
  }
  override public function do_pursue(){
    var last = arr.last();
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
              generate(gen).fold(
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
        () -> generate(gen).fold(
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
  function generate<T>(iterator:Iterator<T>):Option<T>{
    return if(iterator.hasNext()){
      Some(iterator.next());
    }else{
      None;
    }
  }
  override public function do_escape(){
    
  }
  override public function do_cleanup(){
    this.gen = [].iterator();
    this.arr = [];
  }
}