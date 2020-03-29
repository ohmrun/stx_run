package stx.run.pack.task.term;

import stx.core.alias.StdArray;

class All extends Base{
  var gen   : Void->Option<Task>;
  var arr   : StdArray<Task>;
  var init  : Bool;

  public function new(gen:Void->Option<Task>){
    this.gen  = gen;
    this.arr  = [];
    this.init = false;
    super();
  }
  override public function do_escape(){
    for(task in arr){
      task.escape();
    }
  }
  override public function do_cleanup(){
    this.gen = () -> None;
    this.arr = [];
  }
  override public function do_pursue(){
    var recurring = true;
    if(!init){
      init = true;
      for(task in Generator.yielding(gen)){
        task.pursue();
        arr.push(task);
      }
    }
    if(arr.all(
      (x) -> switch(x.progress.data){
        case Pending  : true;
        default       : false;
      }
    )){
      recurring = false;
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