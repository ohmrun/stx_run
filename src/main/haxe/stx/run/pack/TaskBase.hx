package stx.run.pack;

import stx.run.head.data.Task in TaskT;
import tink.concurrent.Mutex;

/**
  Shamelessly pilferred from tink.
**/
class TaskBase implements TaskT {
  /**
   * Locks are generally not the best idea. Given the intended life cycle of a task,
   * this should not be an issue. Since the `perform` or `cancel` method of a single `Task` are 
   * highly unlikely to be invoked heavily, there is no danger of a life lock.
   */
  var m:Mutex;
  
  @:isVar public var state(get, set):TaskState;
  
    public function get_state() return state;
    public function set_state(s:TaskState) return state = s;
  
  public function release():Void 
    exec(function () {
      state = Done(None);
      doRelease();
      doCleanup();
    });
  
  function exec(f) {
    if (!m.tryAcquire()) return;
    
    switch(state){
      case Busy(Ready) : 
        try f()
          catch (e:Dynamic) {
            m.release();
            this.state = Done(Some(__.fault().of(UnknownAutomationError(e))));
          }
      default:
    }
    m.release();
  }
  
  public function perform():Void 
    exec(function () {
      state = Busy(Unknown);
      doPerform();  
      switch(state){
        case Done(_) :
          doCleanup();
        default:
      }
    });
  
  public function new() {
    this.state      = Busy(Ready);
    this.m          = new Mutex();
  }
  
  function doPerform() {
    this.state = Done(None);
  }
  function doRelease() {}
  function doCleanup() {}

  public function definition(){
    return std.Type.getClass(this);
  }  
  public var uuid(default,null) : String = __.uuid();
}