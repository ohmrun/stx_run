package stx.run.pack;

@:forward abstract Runtime(RuntimeDef) from RuntimeDef{
  static public var ZERO(default,null) : Runtime = new RuntimeApiBase();
}
typedef RuntimeDef = {
  public function enter(fn:Report<Dynamic>->Tick):Void;
}
class RuntimeApiBase{
  public function new(){}
  public function enter(fn:Report<Dynamic>->Tick){
    var waits = 0;
    var inner: Bool -> Void = null;
        inner = (waiting:Bool) -> {
          var event : MainEvent = null;
              event = MainLoop.add(
                () -> {
                  if(!waiting){
                    var status = fn(Report.unit());
                    //trace('waiting: $waiting status = $status');
                    switch(status){
                      case Tick.Busy(wake): 
                        waiting = true;
                        wake(
                          () -> {
                            waiting = false;
                          }
                        );
                        //BackOff?
                      case Tick.Poll(milliseconds) : 
                        event.delay(milliseconds == null ? null : (@:privateAccess milliseconds.toSeconds().prj()));
                      case Tick.Fail(e):
                        fn(Report.pure(e));
                      case Tick.Exit:
                        event.stop();
                    }
                  }
                }
          );
    }
    inner(false);
  }
}