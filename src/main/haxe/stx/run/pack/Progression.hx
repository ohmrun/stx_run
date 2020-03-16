package stx.run.pack;

@:forward abstract Progression(Unique<ProgressSum>) from (Unique<ProgressSum>){
  public function new(self){
    return this = self;
  }
  
  static public inline function _() return Constructor.ZERO;

  static public function make(sum:ProgressSum):Progression        return _().make(sum);
  static public function pure(sum:ProgressSum):Progression        return _().pure(sum);
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public function make(sum:ProgressSum):Progression{
    return new Progression(Unique.pure(sum));
  }
  public function pure(sum:ProgressSum):Progression{
    return make(sum);
  }
}