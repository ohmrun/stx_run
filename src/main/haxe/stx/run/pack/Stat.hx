package stx.run.pack;

class Stat{
  static public function unit(){
    return new Stat(new Clock(),null,null,null);
  }
  static public function pure(clock:Clock){
    return new Stat(new Clock(),null,null,null);
  }
  public var uuid(default,null):String;
  private var clock(default,null):Clock;
  private function new(
    clock:Clock,
    accessed=1,
    ?total_runtime:Seconds,
    ?total_waiting:Seconds,
    ?pos:Pos
  ){
    this.uuid             = __.uuid('xxxxx');
    
    //trace('$pos $uuid');
    this.clock            = clock;
    this.accessed         = accessed;
    this.total_runtime    = __.option(total_runtime).defv(1.0);
    this.total_waiting    = __.option(total_waiting).defv(1.0);
  }
  public var accessed(default,null)       : Int;
  
  public var total_runtime(default,null)  : Seconds;
  public var total_waiting(default,null)  : Seconds;

  public var last_runtime(default,null)   : Null<Seconds>;
  public var last_waiting(default,null)   : Null<Seconds>;
  
  public var last_access(default,null)    : Null<Seconds>;
  

  

  public function enter(){
    this.accessed = this.accessed + 1;
    if(this.last_access != null){
      if(this.last_runtime!=null){
        this.last_waiting   = clock.pure(this.last_access + this.last_runtime).delta();
        this.total_waiting  = this.total_waiting + this.last_waiting;
      }
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
  public function add(that:Stat):Stat{
    return if(this.uuid == that.uuid){
      this;
    }else{
      return new Stat(
        this.clock,
        this.accessed         + that.accessed,
        this.total_runtime    + that.total_runtime,
        this.total_waiting    + that.total_waiting
      );
    }
  }
  public function toString(){
    var ac = this.accessed;
    var rt = total_runtime;
    var wt = total_waiting;
    return '$uuid: accessed $ac runtime $rt waiting $wt';
  }
}