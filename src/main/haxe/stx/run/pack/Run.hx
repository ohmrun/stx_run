package stx.run.pack;

//import stx.run.pack.run.term.Eager;
import stx.run.pack.run.term.Base;

@:forward abstract Run(RunApi) from RunApi{
  static public function _() return Constructor.ZERO;
  
  private function new(fn) this = fn;

  static public function unit():Run         return _().unit();
}
private class Constructor extends Clazz{
  public var _(default,never)           = new Destructure();
  static public var ZERO(default,never) = new Constructor();

  public function unit():Run{
    return new Base().asRunApi();
  }
}
class Destructure extends Clazz{
  
}