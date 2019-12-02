package stx.runloop.pack;

class Amb extends TaskBase{
  var owner(get,null) : RunLoop;
  function get_owner(){
    return RunLoop.current;
  }
  var gen   : Void->Option<Task>;
  var arr   : StdArray<Task>;
  var init  : Bool;

  public function new(gen){
    this.gen  = gen;
    this.arr  = [];
    this.init = false;
    super(true);
  }
  override public function doCancel(){
    arr.iter(
      (x) -> {
        if(x.state != Canceled){
          x.cancel();
        }
      }
    );
  }
  override public function doCleanup(){
    this.gen = () -> None;
    this.arr = [];
  }
  override public function doPerform(){
    if(!init){
      init = true;
      Generator.yielding(gen).map(
        (x) -> owner.work(x)
      ).iter(arr.push);
    }
    if(arr.ds().all(
      (x) -> x.state == Performed
    )){
      this.recurring = false;
    }
    if(arr.ds().any(
      (x) -> x.state == Canceled
    )){
      this.recurring = false;
      this.cancel();
    }
  }
}