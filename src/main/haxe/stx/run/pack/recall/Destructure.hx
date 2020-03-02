package stx.run.pack.recall;

class Destructure extends Clazz{
  public function fulfill<I,O,R>(i:I,rcl:Recall<I,O,R>):Recall<Noise,O,R>{
    return Recall.anon((_,cb) -> rcl.duoply(i,cb));
  }
  public function deliver<I,O,R>(cb:O->Void,rcl:Recall<I,O,R>):I -> R{
    return (i) -> rcl.duoply(i,cb);
  }
  public function map<I,O,OO,R>(fn:O->OO,rcl:Recall<I,O,R>):Recall<I,OO,R>{
    return Recall.anon(
      (i,cont) -> rcl.duoply(i,
        (o)->cont(fn(o))
      )
    );
  }
}