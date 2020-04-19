package stx.run.pack.act.term;

import haxe.MainLoop;

class Base implements ActApi{
  public function new(){
    
  }
  public function upply(thk:Void->Void){
    throw "UNIMPLEMENTED ABSTRACT FUNCTION";
  }
  final public function reply():Future<Noise>{
    //trace("BASE::APPLY");
    var ft    = Future.trigger();
    this.upply(
      () -> {
        ft.trigger(Noise);
      }
    );
    return ft;
  }
  public function report(e:Err<Dynamic>):Void{
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