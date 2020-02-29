package stx.run.pack;

abstract Run((Void->Void)->Void){
  static public var instance = (thk) -> thk();
  //static public function lift(fn:(Void->Void)->Void) return new Run();
  private function new() this = instance;
}