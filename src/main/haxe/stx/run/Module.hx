package stx.run;

import stx.run.module.*;

class Module{
  public function new(){}
  public inline function bang():BangDef{
    return Bang.inj().unit();
  }
  public function delay(milliseconds:Int):ReactorDef<Noise>{
    return Reactor.inj().into(
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