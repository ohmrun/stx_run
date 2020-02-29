package stx.run.pack;

class Backoff{
  public var timer(default,null) : Timer;
  public var delta(default,null) : Int;//milliseconds
  
  private function new(timer,delta = 200){
    this.timer = __.option(timer).defv(__.timer());
    this.delta = delta;
  }
  static public function unit(){
    return new Backoff(Timer.unit());
  }
  public function next():Backoff{
    return new Backoff(timer,Math.round(delta*1.2));
  }
  public function over():Backoff{
    return new Backoff(Timer.unit());
  }
  public function roll(){
    var n = next();
    this.delta = n.delta;
  }
  public function ready(){
    return this.timer.created + delta >= now();
  }
  inline function now():Float{
    return Timer.unit().created;
  }
}