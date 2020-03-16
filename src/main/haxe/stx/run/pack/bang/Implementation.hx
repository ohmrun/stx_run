package stx.run.pack.bang;

class Implementation{
  static public inline function inj() return new Constructor();

  public function perform(self:Bang,fn:Void->Void):Bang     return inj()._.perform(fn,self);
}