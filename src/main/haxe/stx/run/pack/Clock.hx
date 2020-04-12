package stx.run.pack;

typedef ClockDef = {
  public var start(default,null):Seconds;

  public function unit():Clock;
  public function pure(start:Seconds):Clock;
   
  public function step():Clock;

  public function delta():Seconds;
  public function stamp():Seconds;
  
}
@:forward abstract Clock(ClockDef) from ClockDef{
  public function new(){
    this =  new ClockImp();
  }
}
private class ClockImp{
  public var start(default,null):Seconds;
  public function new(?start:Null<Seconds>){
    this.start = __.option(start).defv(this.stamp());
  }
  public function pure(start):Clock{
    return new ClockImp(start);
  }
  public function unit():Clock{
    return pure(stamp());
  }
  public function delta():Seconds{
    return stamp() - start;
  }
  public function stamp():Seconds{
    return haxe.Timer.stamp();
  }
  public function step():Clock{
    return unit();
  }
}