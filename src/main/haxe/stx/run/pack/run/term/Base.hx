package stx.run.pack.run.term;

import haxe.MainLoop;

class Base implements RunApi{
  public function new(){}
  var event : MainEvent;
  var fn    : Void->Tick;

  public function upply(schedule:Schedule):Void{
    __.log().close().trace("BASE::UPPLY");
    this.fn    = schedule.reply;
    this.event = MainLoop.add(close);
  }
  public function apply(schedule:Schedule):Bang{
    __.log().close().trace("BASE::APPLY");
    var ft      = __.future();
    var wrapper = Schedule.Anon(
      () -> {
        __.log().close().trace("HEHER");
        var out = schedule.reply();
        if(out.match(Exit)){
          ft.fst().trigger(Noise);
        }
        return out;
      }
    );
    return Bang._().fromFuture(ft.snd());
  }
  private function close(){
    __.log().close().trace("BASE::CLOSE");
    switch(fn()){
      case Exit               : 
        event.stop();
      case Poll(milliseconds) :
        event.delay(milliseconds/1000);
      case Busy               :
      case Fail(e)            :
        event.stop();
        report(e);
    }
  }
  public function report(e:Err<Dynamic>):Void{
    Act.MainThread().upply(
      () -> {
        throw(e);
      }
    );
  }
  public function asRunApi():RunApi{
    return this;
  }
}