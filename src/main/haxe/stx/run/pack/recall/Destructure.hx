package stx.run.pack.recall;

class Destructure extends Clazz{
  public function fulfill<I,O,R>(i:I,rcl:Recall<I,O,R>):Recall<Noise,O,R>{
    return Recall.Anon((_,cb) -> rcl.applyII(i,cb));
  }
  public function deliver<I,O,R>(cb:O->Void,rcl:Recall<I,O,R>):I -> R{
    return (i) -> rcl.applyII(i,cb);
  }
  public function map<I,O,OO,R>(fn:O->OO,rcl:Recall<I,O,R>):Recall<I,OO,R>{
    return Recall.Anon(
      (i,cont) -> rcl.applyII(i,
        (o)->cont(fn(o))
      )
    );
  }
  public function map_r<I,O,R,RR>(fn:R->RR,rcl:Recall<I,O,R>):Recall<I,O,RR>{
    return Recall.Anon(
      (i,cont) -> fn(rcl.applyII(i,cont))
    );
  }
}