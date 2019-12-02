package stx.runloop.pack;

class Seq extends TaskBase{
  
  var owner(get,null) : RunLoop;
  function get_owner(){
    return RunLoop.current;
  }
  var gen : Void->Option<Task>;
  var arr : StdArray<Task>;

  public function new(gen){
    this.gen = gen;
    this.arr = [];
    super(true);
  }

  override public function doPerform(){
    switch(this.state){
      case Pending:
        if(arr.length == 0){
          switch(gen()){
            case Some(v) : 
              arr.push(v);
              owner.work(v);
            case None:
              this.recurring = false;
          }
        }else{
          var last = arr[arr.length-1];
          switch (last.state){
            case Pending: 
              owner.work(last);
            case Canceled:
              this.cancel();
            case Performed:
              switch(gen()){
                case Some(v):
                  arr.push(v);
                  owner.work(v);
                case None:
                  this.recurring = false;
              }
            default:
          }
        }
      default:
    }
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
}