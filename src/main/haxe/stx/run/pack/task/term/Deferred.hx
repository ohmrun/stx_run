package stx.run.pack.task.term;

class Deferred extends Base{
  var escaped     : Bool;
  var poll        : Backoff;
  var deferred    : Reactor<Task>;
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
  function doDelegate(){
    if(arrived){
      if(escaped){
        this.impl.escape();
      }else{
        this.impl.pursue();
      }
      switch(this.impl.progress.data){
        case Polling(_)         : this.progress = this.impl.progress;
        case Waiting(_)         : this.progress = this.impl.progress;
        case Problem(_)         : this.progress = this.impl.progress;
        
        case Pending            : this.progress = this.impl.progress;

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
    if(!init){
      this.progress = Progression.pure(Pending);
      __.log().close().trace('init');
      init = true;

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
      var later = Reactor.into(reactor);

      this.deferred.upply(
        (x) -> {
          this.impl     = x;
          respond();
          doDelegate();
        }
      );

      if(arrived){
        __.log().close().trace('synchronous');
        doDelegate();
      }else{
        __.log().close().trace('asynchronous');
        this.progress = Progression.pure(Waiting(later));
      }
    }else{
      __.log().close().trace('cont');
      if(__.that().alike().ok(Waiting(null),new EnumValue(this.progress.data).prj())){
        if(arrived){
          doDelegate();
        }else{
          //still waiting, if I'm being called it must be polling time.
          poll.roll();
          this.progress = Progression.pure(Polling(poll.delta));
        }
      }else if(__.that().alike().ok(Polling(null),this.progress.data)){
        if(arrived){
          doDelegate();
        }else{
          if(this.poll.ready()){
            poll.roll();
            this.progress = Progression.pure(Polling(poll.delta));
          }else{
            //not ready, not passed the polling time: ignore.
          }
        }
      }else if(this.impl != null && this.should_pursue()){
        this.impl.pursue();
      }
    }
    return should_pursue();
  }
  override function do_escape(){
    this.escaped = true;
    deferred.upply(
      (task) -> task.escape()
    );
  }
  override public function toDeferred(){
    return this.asTaskApi();
  }
}
