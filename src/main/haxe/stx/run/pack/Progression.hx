package stx.run.pack;

@:forward abstract Progression(Unique<Progress>) from (Unique<Progress>){
  public function new(self){
    return this = self;
  }
  
  static public inline function _() return Constructor.ZERO;

  static public function make(sum:Progress):Progression        return _().make(sum);
  static public function pure(sum:Progress):Progression        return _().pure(sum);

  public function is_less_than(that:Progression){
    return this.data.is_less_than(that.data);
  }
  public function error(){{
    return this.data.error();
  }}
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public function make(sum:Progress):Progression{
    return new Progression(Unique.pure(sum));
  }
  public function pure(sum:Progress):Progression{
    return make(sum);
  }
}