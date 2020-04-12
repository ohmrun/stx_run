package stx.run.pack;

class Backoff{
  public var timer(default,null) : Timer;
  public var delta(default,null) : MilliSeconds;//milliseconds
  
  private function new(timer,delta : MilliSeconds = 200){
    this.timer = __.option(timer).defv(__.timer());
    this.delta = delta;
  }
  static public function unit(){
    return new Backoff(Timer.unit());
  }
  public function next():Backoff{
    return new Backoff(timer,(delta*1.2).toMilliSeconds());
  }
  public function over():Backoff{
    return new Backoff(Timer.unit());
  }
  public function roll(){
    var n = next();
    this.delta = n.delta;
  }
  public function ready(){
    return !((this.timer.created + delta.toSeconds()) >= now());
  }
  inline function now():Seconds{
    return Timer.unit().created;
  }
}