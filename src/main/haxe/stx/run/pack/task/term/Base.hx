package stx.run.pack.task.term;

import stx.run.pack.task.Interface in TaskT;
import tink.concurrent.Mutex;

/**
  Shamelessly pilferred from tink.
**/
class Base implements TaskT {
  /**
   * Locks are generally not the best idea. Given the intended life cycle of a task,
   * this should not be an issue. Since the `pursue` or `cancel` method of a single `Task` are 
   * highly unlikely to be invoked heavily, there is no danger of a life lock.
   */
  var m:Mutex;
  
  @:isVar public var progress(get, set):Progression;
  
    public function get_progress() return progress;
    public function set_progress(progress:Progression) return this.progress = progress;
  
  public var working(get,null): Bool;
  public function get_working():Bool{
    return switch(progress.data){
      case Unready | Polling(_) | Waiting(_) | Reready : true;
      default : false;
    }
  }
  public var hanging(get,null): Bool;
  public function get_hanging():Bool{
    return switch(progress.data){
      case Unready | Polling(_) | Waiting(_) : true;
      default : false;
    }
  }

  final public function escape():Void 
    exec(function () {
      progress = Unique.pure(Already);
      doEscape();
      doCleanup();
    });
  
  function exec(f) {
    if (!m.tryAcquire()) return;
    
    switch(progress.data){
      case Problem(_) | Already : 
      default : 
        try f()
          catch(e:TypedError<Dynamic>){
            m.release();
            var data = e.map(UnknownAutomationError);
            switch(e.uuid){
              case AutomationError.UUID : 
                this.progress = Unique.pure(Problem(Std.downcast(e,AutomationError)));
              default : 
                this.progress = Unique.pure(Problem(data));
            }
          }catch(e:Dynamic) {
            m.release();
            var data = UnknownAutomationError(e);
            if (Std.string(e) == 'Stack overflow'){
              data = StackOverflow;
            }
          this.progress = Unique.pure(Problem(AutomationError.make(data,None,__.fault().prj())));
          }
    }
    m.release();
  }
  
  final public function pursue():Void 
    exec(function () {
      if(progress == Pending){
        progress = Unique.pure(Unready);
      }
      var cont = doPursue();  
      if(cont == true){
        if(!hanging){
          progress = Unique.pure(Reready);
        }
      }else{
        progress = Unique.pure(Already);
      }
      switch(progress.data){
        case Already :
          doCleanup();
        default:
      }
    });
  
  public function new() {
    this.progress   = Unique.pure(Pending);
    this.m          = new Mutex();
  }
  
  function doPursue():Bool{
    return false;
  }
  function doEscape() {}
  
  function doCleanup() {}

  public inline function definition(){
    return std.Type.getClass(this);
  }  
  public inline function name(){
    return std.Type.getClassName(definition());
  }  
  public var uuid(default,null) : String = __.uuid();

  public function asTask():Interface{
    return this;
  }
  public function asDeferred():Interface{
    return new Deferred(
      Reactor.lift(
        (cb) -> cb(this.asTask())
      )
    ).asTask();
  }
}