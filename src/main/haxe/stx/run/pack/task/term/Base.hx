package stx.run.pack.task.term;


import tink.concurrent.Mutex;

/**
  Shamelessly pilferred from tink.
**/
class Base implements TaskApi extends Clazz{
  /**
   * Locks are generally not the best idea. Given the intended life cycle of a task,
   * this should not be an issue. Since the `pursue` or `cancel` method of a single `Task` are 
   * highly unlikely to be invoked heavily, there is no danger of a life lock.
   */
  var m:Mutex;
  
  @:isVar public var progress(get, set):Progression;
  
    public function get_progress() return progress;
    public function set_progress(progress:Progression) return this.progress = progress;
  
  public var ongoing(get,null): Bool;
  public function get_ongoing():Bool{
    return switch(progress.data){
      case Pending | Polling(_) | Waiting(_) | Working : true;
      default : false;
    }
  }

  final public function escape():Void 
    exec(function () {
      progress = Progression.pure(Escaped);
      do_escape();
      do_cleanup();
    });
  
  function exec(f) {
    if (!m.tryAcquire()) return;
    
    switch(progress.data){
      case Problem(_) | Secured | Escaped : 
      default : 
        try f()
          catch(e:Err<Dynamic>){
            m.release();
            var data = e.map(E_UnknownAutomation);
            switch(e.uuid){
              case AutomationError.UUID : 
                this.progress = Progression.pure(Problem(Std.downcast(e,AutomationError)));
              default : 
                this.progress = Progression.pure(Problem(data));
            }
          }catch(e:Dynamic) {
            m.release();
            var data = E_UnknownAutomation(e);
            if (Std.string(e) == 'Stack overflow'){
              data = E_StackOverflow;
            }
          this.progress = Progression.pure(Problem(AutomationError.make(data,None,__.here())));
          }
    }
    m.release();
  }
  
  final public function pursue():Void 
    exec(function () {
      var cont = do_pursue();  
      if(cont == true){
        if(!ongoing && !progress.data.prj().match(Pending)){
          progress = Progression.pure(Pending);
        }
      }else{
        progress = Progression.pure(Secured);
      }
      switch(progress.data){
        case Secured | Escaped :
          do_cleanup();
        default:
      }
    });
  
  public var rtid(default,null): Void->Void;
  public function new() {
    super();
    this.progress   = Progression.pure(Pending);
    this.rtid       = () -> {};
    this.m          = new Mutex();
  }
  
  function do_pursue():Bool{
    return false;
  }
  function do_escape() {}
  
  function do_cleanup() {}

  public var uuid(default,null) : String = __.uuid();

  public function asTaskApi():TaskApi{
    return this;
  }
  private function progression(progress){
    this.progress = Progression.pure(progress);
  }
}