package stx.run.pack.act.term;

import haxe.MainLoop;

class Base implements ActApi{
  public function new(){
    
  }
  public function upply(thk:Void->Void){
    throw "UNIMPLEMENTED ABSTRACT FUNCTION";
  }
  final public function apply(thk:Void->Void):Bang{
    trace("BASE::APPLY");
    var ft    = __.future();
    this.upply(
      () -> {
        thk();
        ft.fst().trigger(Noise);
      }
    );
    return Bang._().fromFuture(ft.snd());
  }
  public function report(e:TypedError<Dynamic>):Void{
    Act.MainThread().upply(
      () -> {
        throw(e);
      }
    );
  }
  public function asActApi():ActApi{
    return this;
  }
}