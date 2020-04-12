package stx.run.pack.task.term;

import stx.core.alias.StdArray;

class All extends Base{
  var gen   : Iterator<Task>;
  var arr   : StdArray<Task>;
  var init  : Bool;

  public function new(gen:Iterator<Task>){
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
    this.gen = [].iterator();
    this.arr = [];
  }
  
  override public function do_pursue(){
    var recurring = true;
    if(!init){
      init = true;
      for(task in gen){
        arr.push(task);
      }
    }
    var partition = arr.partition(
      (task) -> switch(task.progress.data){
        case Problem(e) : true;
        default         : false;
      }
    );
    __.log().close().trace(partition);
    return if(partition.a.is_defined()){
      this.progress = Progression.pure(
        Problem(partition.a.lfold(
          (next:Task,memo:Option<Err<AutomationFailure<Dynamic>>>) -> next.progress.error().flat_map(
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
    }else{
      for(task in arr){
        task.pursue();
        if(task.progress.error().is_defined()){
          return true;
        }
      }
      this.progress = Progression.pure(partition.b.lfold1(
        (next:Task,memo:Task) -> memo.progress.is_less_than(next.progress) ? memo : next
      ).map( t -> t.progress.data ).defv(Problem(__.fault().of(E_NoValueFound))));

      switch(progress.data){
        case Pending | Polling(_) | Waiting(_) : true;
        default : false;
      }
    }
  }
}