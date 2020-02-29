package stx.run.pack.automation;

class Destructure{
  var log = __.log().trace;
  private function new(){

  }
  public function seq(fn:Queue->Automation,self:Automation):Automation{
    var f = seq.bind(fn);
    return switch self {
      case Interim(rcv)           : Interim(rcv.map(f));
      case Operate(f1)            : Operate(f1.mod(f));
      case Release(r)             : fn(r);
      case Default(e)             : Default(e);
    }
  }
  public function mod(fn:Queue -> Queue, self:Automation){
    return seq(fn.fn().then(Release),self);
  }
  public function concat(that:Automation,self:Automation):Automation{
    return seq(
      (jobs0) -> that.mod(
        (jobs1) -> jobs0.concat(jobs1)
      ),
      self
    );
  }
  public function cons(task:Task,self:Automation):Automation{
    return mod(
      (jobs) -> jobs.cons(task),
      self
    );
  }
  public function snoc(task:Task,self:Automation):Automation{
    return mod(
      (jobs) -> jobs.cons(task)
    ,self);
  }
  function operate(self:Automation,push:((Void->Void) -> Void),?limit:Limit){
    var profile = Profile.conf(limit);
    
    function cookie_monster(self:Automation){
      switch(self){
        case Interim(ft)          : 
          push(() -> {
            ft(Noise,cookie_monster);
          });
        case Operate(next)        : 
          push(
            () -> { cookie_monster(next(Pursue)); }
          );
        case Release(_.is_defined() => false)        : 
        case Release(jobs)        : 
          jobs.operate(push,limit);
        case Default(e)           : throw e;
      }
    }
    push(cookie_monster.bind(self));    
  }

  inline function sync(thk){
    thk();
  }
  inline function async(thk){
    MainLoop.add(thk);
  }
  /**
    Submit the Automation to the MainLoop;
  **/
  public function submit(self:Automation,?limit){
    operate(
      self,
      async,
      limit
    );
  }
  /**
    Run the Automation inline;
  **/
  public function crunch(self:Automation,?limit){
    operate(
      self,
      sync,
      limit
    );
  }  
}   