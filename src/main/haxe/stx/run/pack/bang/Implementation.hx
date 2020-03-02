package stx.run.pack.bang;

class Implementation{
  static public inline function inj() return new Constructor();

  public function perform(self:BangDef,fn:Void->Void):BangDef     return inj()._.perform(fn,self);
}