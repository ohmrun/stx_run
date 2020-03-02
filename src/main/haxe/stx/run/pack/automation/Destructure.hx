package stx.run.pack.automation;

import stx.run.type.Package.Automation in AutomationT;

class Destructure extends Clazz{
  var log = __.log().trace;

  public function seq(fn:Queue->Automation,self:Automation):Automation{
    return switch self {
      case Interim(rcv)           : Interim(
        rcv.map(
          function(chomp:Automation):AutomationT { return switch(chomp){
            case Default(e)   : Default(e);
            case Operate(o)   : Operate(o.mod(seq.bind(fn)));
            case Interim(rct) : Interim(
              rct.map(
                function (chomp) return seq(fn,chomp).prj()
              )
            );
            case Release(q)   : Operate(
              Operation.fromThunk(
                () -> seq(fn,fn(q))
              )
            );
          }
        })
      );
      case Operate(f1)            : Operate(f1.mod(seq.bind(fn)));
      case Release(r)             : fn(r).prj();
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
            ft.upply(cookie_monster);
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