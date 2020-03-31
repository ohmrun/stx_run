package stx.run.pack;

@:forward abstract Bang(BangDef) from BangDef to BangDef {
  static public function unit():Bang{
    return Reactor.into(
      (handler) -> handler(Noise)
    ).asRecallDef();
  }
  static public function fromFuture(ft:Future<Noise>):Bang{
    return Recall.Anon(
      (_:Noise,cb) -> ft.handle(cb)
    );
  }
  public function perform(self:Bang,fn:Void->Void):Bang{
    return Recall.Anon(
      (_:Noise,cb:Noise->Void) -> {
        fn();
        cb(Noise);
      }
    );
  }
}