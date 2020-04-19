package stx.run.pack;

class Stat{
  private var clock(default,null):Clock;
  public function new(clock:Clock){
    this.clock            = clock;
    this.accessed         = 1;
    this.total_runtime    = 1;
    this.total_waiting    = 1;
  }
  var last_access(default,null)    : Null<Seconds>;
  var last_runtime(default,null)   : Null<Seconds>;
  var last_waiting(default,null)   : Null<Seconds>;
  
  var total_waiting(default,null)  : Seconds;
  var total_runtime(default,null)  : Seconds;

  var accessed(default,null)       : Int;

  public function enter(){
    this.accessed = this.accessed + 1;
    if(this.last_access != null){
      this.last_waiting   = clock.pure(this.last_access + this.last_runtime).delta();
      this.total_waiting  = this.total_waiting + this.last_waiting;
    }
    this.last_access  = clock.stamp();
  }
  public function leave(){
    this.last_runtime = clock.pure(last_access).delta();
    total_runtime     = last_runtime + total_runtime;
  }
  public function value():Float{
    //trace('$total_waiting $total_runtime');
    var a           = (total_waiting / total_runtime );
    var b : Seconds = accessed + 1;
    var c           = a * b;
    var d           = @:privateAccess c.prj();
    return d;
  }
}