package stx.run.pack;

import haxe.MainLoop.MainLoop;
import haxe.MainLoop.MainEvent;

interface RuntimeApi{
  public function run(scheduler:Scheduler):Void;
}
class RuntimeBase implements RuntimeApi{
  public function new(){
    run(Scheduler.ZERO);
  }
  public function run(scheduler:Scheduler):Void{
    var event : MainEvent = null;
        event = MainLoop.add(
          () -> {
            var status = scheduler.status();
            __.log().close().trace('run: $status');
            switch(status){
              case Busy: 
                scheduler.pursue();
              case Poll(milliseconds) : 
                scheduler.pursue();
                event.delay(milliseconds == null ? null : (@:privateAccess milliseconds.toSeconds().prj()));
              case Fail(e):
                event.stop();
                scheduler.escape();
                MainLoop.runInMainThread(
                  () -> {
                    throw(e);
                  }
                );
              case Exit:
                event.stop();
            }
          }
        );
  }
}
@:forward abstract Runtime(RuntimeApi) from RuntimeApi{
  public function new(self) this = self;
  static public var ZERO(default,never) = new RuntimeBase();
  static public function run(scheduler:Scheduler):Void{
    ZERO.run(scheduler);
  }
}