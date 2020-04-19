package stx.run.pack.task.term;


import tink.concurrent.Mutex;

/**
  Shamelessly pilferred from tink.
**/
class Base implements TaskApi extends Clazz{
  
  @:isVar public var progress(get, set):Progression;
  
    public function get_progress() return progress;
    public function set_progress(progress:Progression) return this.progress = progress;


  final public function escape():Void 
    exec(function () {
      progression(Escaped);
      do_escape();
      do_cleanup();
    });
  
  function exec(f) {
    switch(progress.data){
      case Problem(_) | Secured | Escaped : 
      default : 
        try f()
          catch(e:Err<Dynamic>){
            var data = e.map(E_UnknownAutomation);
            switch(e.uuid){
              case RunError.UUID : 
                progression(Problem(Std.downcast(e,RunError)));
              default : 
                progression(Problem(data));
            }
          }catch(e:Dynamic) {
            var data = E_UnknownAutomation(e);
            if (Std.string(e) == 'Stack overflow'){
              data = E_StackOverflow;
            }
            progression(Problem(RunError.make(data,None,__.here())));
          }
    }
  }
  
  final public function pursue():Void 
    exec(function () {
      var cont = do_pursue();  
      switch(progress.data){
        case Secured | Escaped :
          do_cleanup();
        default:
      }
    });
  
  public var rtid(default,null): Void->Void;
  public function new() {
    super();
    this.rtid       = () -> {};
    progression(Pending);
  }
  
  private function do_pursue():Bool{
    return false;
  }
  private function do_escape() {}
  
  private function do_cleanup() {}

  public var uuid(default,null) : String = __.uuid();

  public function asTaskApi():TaskApi{
    return this;
  }
  private function progression(progress,?pos:Pos){
    this.progress = Progression.pure(progress);
  }
  public function toString(){
    var name = this.identifier().split(".").last().defv("");
    return '$name ${progress.data}';
  }
}