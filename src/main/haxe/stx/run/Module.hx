package stx.run;

import stx.run.module.*;

class Module{
  public function new(){}
  public inline function bang():Bang{
    return Bang.unit();
  }
  public function delay(milliseconds:Int):Reactor<Noise>{

    return Reactor.inj.call(
      (cb) -> {
        defer(
          () -> haxe.Timer.delay(cb.bind(Noise),milliseconds)
        );
      }
    );
  }
  public function defer(fn:Void->Void):Void{
    haxe.MainLoop.add(fn);
  }
}