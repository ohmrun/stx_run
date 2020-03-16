package stx.run.pack.bang;

class Destructure extends Clazz{
  public static var ZERO(default,never) = new Destructure();

  public function perform(fn:Void->Void,self:Bang):Bang{
    return Recall.Anon(
      (_:Noise,cb:Noise->Void) -> {
        fn();
        cb(Noise);
      }
    );
  }
}