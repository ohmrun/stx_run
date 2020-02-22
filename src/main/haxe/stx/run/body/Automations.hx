package stx.run.body;

import stx.run.head.data.UIO in UIOT;
import stx.run.head.data.Automation in AutomationT;

@:noUsing class Automations extends Clazz{
  public function seq(fn:JobQueue->Automation,thiz:Automation):Automation{
    return Proxies.fmap(
      thiz.prj(),
      fn.broker(
        (F) -> 
          F.then(__.arw().fn())
            .then( 
              (_:Arrowlet<JobQueue,Automation>) -> _.postfix(x -> x.prj()) 
            )
      )
    ).broker(
      (F) -> F.then(Automation.lift)
    );
  }
  public inline function cons(that:Automation,thiz:Automation):Automation{
    return that.seq(
      (jobs) -> Automation.lift(thiz)
    );
  }
  public inline function concat(that:Automation,thiz:Automation):Automation{
    return Automation.lift(Proxies.fmap(
      thiz.prj(),
      (l_jobs:JobQueue) -> Proxies.fmap(
        that.prj(),
        __.arw().fn()((r_jobs) -> Ended(Val(l_jobs.concat(r_jobs))))
      )
    ));
  }
  public inline function snoc(task:Task,lhs:Automation):Automation{
    return Automation.lift(Proxies.fmap(
      lhs.prj(),
      (l_jobs:JobQueue) -> Ended(Val(l_jobs.snoc(task)))
    ));
  }
  public function crunch(self:Automation){
    function cookie_monster(self){
      switch(self){
        case Later(ft)          : cookie_monster(ft(cookie_monster));
        case Yield(jobs,next)   : 
          if(jobs.is_defined()){
            throw jobs; 
          }
          cookie_monster(next.prepare(Noise,Continue.unit()));
        case Await(jobs,next)   : 
          if(jobs.is_defined()){
            throw jobs;
          }
          cookie_monster(next.prepare(Noise,Continue.unit()));
        case Ended(End(e))      : e.throwSelf();
        case Ended(_)           : 
        default:
          trace(self);
      }
    };
    cookie_monster(self);
  }
  public function submit(self:Automation){
    var push = (thk) -> {
      //trace('add');
      // thk = ()->{
      //   trace('calling');
      //   thk();
      // }
      MainLoop.add(thk);
    }
    function cookie_monster(self:AutomationT){
      //trace('cookie');
      switch(self){
        case Later(ft)          : 
          push(() -> {
            var res = ft(cookie_monster);
            submit(res);
          });
        case Yield(jobs,next)   : 
          if(jobs.is_defined()){
            throw jobs;
          }
          push(cookie_monster.bind(next.prepare(Noise,Continue.unit())));
        case Await(jobs,next)   : 
          if(jobs.is_defined()){
            throw jobs;
          }
          push(cookie_monster.bind((next.prepare(Noise,Continue.unit()))));
        case Ended(End(e))      : e.throwSelf();
        case Ended(_)           : 
        default:
          trace(self);
      }
    }
    push(cookie_monster.bind(self));
  }
}
