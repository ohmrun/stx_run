package stx.run.pack.task.term;

import stx.core.alias.StdArray;

class All extends Base{
  var arr   : StdArray<Task>;
  var init  : Bool;

  public function new(arr:Array<Task>){
    this.arr  = arr;
    this.init = false;
    super();
  }
  override private function do_escape(){
    for(task in arr){
      task.escape();
    }
  }
  override public function do_cleanup(){
    this.arr = [];
  }
  
  override private function do_pursue(){
    var recurring = true;
    if(!init){
      init = true;
    }
    var partition = arr.partition(
      (task) -> switch(task.progress.data){
        case Problem(e) : true;
        default         : false;
      }
    );
    return if(partition.a.is_defined()){
      this.progress = Progression.pure(
        Problem(partition.a.lfold(
          (next:Task,memo:Option<Err<RunFailure<Dynamic>>>) -> next.progress.error().flat_map(
            (e) -> memo.map(
              (e2) -> e2.next(e)
            )
          ),
          None
        ).defv(__.fault().of(E_NoValueFound)))
      );
      for(task in partition.b){
        task.escape();
      }
      false;
    }else if(!partition.b.is_defined()){
      progression(Secured);
      false;
    }else{
      for(task in arr){
        task.pursue();
        if(task.progress.error().is_defined()){
          return true;
        }
      }
      progression(partition.b.lfold1(
        (next:Task,memo:Task) -> memo.progress.is_less_than(next.progress) ? memo : next
      ).map( t -> t.progress.data ).defv(Problem(__.fault().of(E_NoValueFound))));

      switch(progress.data){
        case Pending | Polling(_) | Waiting(_) : true;
        default : false;
      }
    }
  }
}