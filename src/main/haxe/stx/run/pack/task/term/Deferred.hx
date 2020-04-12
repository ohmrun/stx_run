package stx.run.pack.task.term;

class Deferred extends Base{
  var escaped     : Bool;
  var poll        : Backoff;
  var deferred    : Future<Task>;
  var impl        : Task;
  var init        : Bool;

  var arrived(get,null):Bool;
    function get_arrived(){
    return impl != null;
  }
  public function new(deferred){
    super();
    this.deferred   = deferred;
    this.poll       = Backoff.unit();
  }
  function do_delegate(){
    __.log().close().trace('Deferred#do_delegate arrived:$arrived escaped:$escaped');
    if(arrived){
      if(escaped){
        this.impl.escape();
      }else{
        this.impl.pursue();
      }
      __.log().close().trace(this.impl);
      __.log().close().trace(this.impl.progress.data);
      switch(this.impl.progress.data){
        case Polling(_)         : this.progress = this.impl.progress;
        case Waiting(_)         : this.progress = this.impl.progress;
        case Problem(_)         : this.progress = this.impl.progress;
        
        case Pending            : this.progress = this.impl.progress;
        case Working            : this.progress = this.impl.progress;

        case Secured            : this.progress = this.impl.progress;
        case Escaped            : this.progress = this.impl.progress;
      }
    }
    return should_pursue();
  }  
  inline function should_pursue(){
    return switch(progress.data){
      case Pending | Waiting(_) | Polling(_)  : true;
      default                                 : false;
    }
  }
  override function do_pursue(){
    __.log().close().trace("Deferred#do_pursue");
    if(!init){
      this.progress = Progression.pure(Pending);
      init = true;
      __.log().close().trace('Deferred#do_pursue({init : true})');

      var cbs        = [];
      var reactor    = (cb:Noise->Void) -> {
        cbs.push(cb);
      };
      var respond    = () ->{
        while(true){
          var next = cbs.shift();
          if(next == null){
            break;
          }
          next(Noise);
        }
      }
      var later = Future.async(reactor);

      this.deferred.handle(
        (x) -> {
          __.log().close().trace('Deferred#handle $x');
          this.impl     = x;
          respond();
          do_delegate();
        }
      );

      if(arrived){
        __.log().close().trace('synchronous');
        do_delegate();
      }else{
        __.log().close().trace('asynchronous');
        this.progress = Progression.pure(Waiting(later));
      }
    }else{
      __.log().close().trace('Deferred#do_pursue({init : false}) ${this.progress.data}');
      if(__.that().alike().ok(Waiting(null),new EnumValue(this.progress.data).prj())){
        if(arrived){
          do_delegate();
        }else{
          //still waiting, if I'm being called it must be polling time.
          poll.roll();
          this.progress = Progression.pure(Polling(poll.delta));
        }
      }else if(__.that().alike().ok(Polling(null),this.progress.data)){
        if(arrived){
          do_delegate();
        }else{
          if(this.poll.ready()){
            __.log().close().trace("ready");
            poll.roll();
            this.progress = Progression.pure(Polling(poll.delta));
          }else{
            __.log().close().trace("not ready");
            //not ready, not passed the polling time: ignore.
          }
        }
      }else if(this.impl != null && this.should_pursue()){
        __.log().close().trace('Deferred#do_pursue({ case : "default" })');
        do_delegate();
      }
    }
    return should_pursue();
  }
  override function do_escape(){
    this.escaped = true;
    deferred.handle(
      (task) -> task.escape()
    );
  }
}
