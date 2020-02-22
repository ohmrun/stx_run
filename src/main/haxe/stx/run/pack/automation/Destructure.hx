package stx.run.pack.automation;

class Destructure{
  private function new(){}
  public function seq(fn:JobQueue->Automation,self:Automation):Automation{
    return switch self {
      case Interim(v: Receiver<Chomp<R,E>>);//event architecture
      case Operate(ch: Unary<Op,Chomp<R,E>>);//thread architecture
      case Release(v:R);//completion
      case Default(e:TypedError<E>);//error
    }
    return Proxies.fmap(
      self.prj(),
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
  public inline function cons(that:Automation,self:Automation):Automation{
    
  public inline function concat(that:Automation,self:Automation):Automation{
    return self.fmap(
      (jobs0) -> that.map(
        (jobs1) -> Release(jobs0.concat(jobs1))
      )
    );
  }
  public inline function snoc(task:Task,lhs:Automation):Automation{
    return Automation.lift(Proxies.fmap(
      lhs.prj(),
      (l_jobs:JobQueue) -> Release(l_jobs.snoc(task))
    ));
  }
  function operate(self:Automation,push:(Void->Void) -> Void){
    function cookie_monster(self:AutomationT){
      //trace('cookie');
      switch(self){
        case Interim(ft)          : 
          push(() -> {
            var res = ft(cookie_monster);
            submit(res);
          });
        case Operate(next)   : 
          push(
            () -> { cookie_monster(next()); }
          );
        case Default(e)         : throw e;
      }
    }
    push(cookie_monster.bind(self));    
  }
  public function submit(self:Automation){
    operate(
      self,
      (thk) -> MainLoop.add(thk)
    );
  }
  public function crunch(self:Automation){
    operate(
      self,
      (thk) -> thk()
    );
  }  
}