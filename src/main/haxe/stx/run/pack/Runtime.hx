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
    //trace('enter');
    var inner: Bool -> Void = null;
        inner = (waiting:Bool) -> {
          var event : MainEvent = null;
              event = MainLoop.add(
                () -> {
                  //trace('running');
                  if(!waiting){
                    var status = fn(Report.unit());
                    switch(status){
                      case Tick.Busy(wake): 
                        waiting = true;
                        wake(inner.bind(false));
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