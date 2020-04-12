package stx.run.pack;

class Profile{
  public var references(default,null)   : Int;
  private var timer                     : Timer;
  private var progress                  : Block;
  
  public var limit(default,null):Limit;
  public var repeats(default,null):Int;//how many times has this task been repeated?
  public var changed(default,null):Int;//at which repeat did this last change?
  public var modified(default,null):Seconds;//when did the progression last change?

  @:noUsing static public function conf(?limit:Limit):Profile{
    return new Profile(null,limit);
  }
  private function new(?timer:Timer,?limit,repeats = 0,changed = 0,?modified,?progress,?references = 0){
    this.limit            = __.option(limit).defv({});
    this.limit.unchanged  = __.option(this.limit.unchanged).defv(be.Constant.I.MAX);
    this.limit.duration   = __.option(this.limit.duration).defv(be.Constant.I.MAX);
    this.limit.hanging    = __.option(this.limit.duration).defv(be.Constant.I.MAX);

    this.timer            = __.option(timer).def(Timer.unit);
    this.repeats          = repeats;
    this.changed          = changed;
    this.progress         = progress;
    this.modified         = __.option(modified).def(Timer.mark);
    this.references       = 0;
  }
  function copy(?timer,?limit,?repeats,?changed,?modified,?progress,?references){
    return new Profile(
      __.option(timer).defv(this.timer),
      __.option(limit).defv(this.limit),
      __.option(repeats).defv(this.repeats),
      __.option(changed).defv(this.changed),
      __.option(modified).defv(this.modified),
      __.option(progress).defv(this.progress),
      __.option(references).defv(this.references)
    );
  }
  public function next(progress:Block){
    return (this.progress.equals(progress)).if_else(
      () -> repeat(),
      () -> change()
    );
  }
  @:impure
  public function roll(progress:Block){
    var n = this.next(progress);
    this.repeats    = n.repeats;
    this.changed    = n.changed;
    this.modified   = n.modified;
    
    this.progress   = progress;
  }
  public function test(){
    var since_creation = this.timer.since().toMilliSeconds();
    var since_change   = Timer.pure(this.modified).since().toMilliSeconds();
    var since_changed  = this.repeats - this.changed;

    return 
      this.limit.duration > since_creation && 
      this.limit.hanging > since_change && 
      this.limit.unchanged > since_changed;
  }
  inline function now(){
    return Timer.unit().created;
  }
  public function repeat(){
    return new Profile(timer,limit,repeats+1,changed,modified,progress,references);
  }
  public function change(){
    return new Profile(timer,limit,repeats+1,repeats+1,null,progress,references);
  }

  public function inc(){
    return new Profile(timer,limit,repeats,changed,modified,progress,references+1);
  }
  public function dec(){
    return new Profile(timer,limit,repeats,changed,modified,progress,references-1);
  }
  
}