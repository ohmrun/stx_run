package stx.run.pack.bang;

class Destructure extends Clazz{
  public static var ZERO(default,never) = new Destructure();

  public function perform(fn:Void->Void,self:BangDef):BangDef{
    return Recall.anon(
      (_:Noise,cb:Noise->Void) -> {
        fn();
        cb(Noise);
      }
    );
  }
}