package stx.run.pack;

import stx.proxy.core.head.data.Proxy in ProxyT;

import stx.run.head.data.UIO in UIOT;
import stx.run.head.data.Automation in AutomationT;
import stx.run.head.Automations;

abstract Automation(AutomationT) to AutomationT{
  public function new(self:AutomationT) this = self;
  static public inline function lift(self:AutomationT)          return new Automation(self);

  @:noUsing static public function fromTask(t:Task)             return lift(Ended(JobQueue.unit().snoc(t)));
  @:noUsing static public function unit<E>():Automation         return Automations.unit();
  @:noUsing static public function pure<E>(jobs):Automation     return Automations.pure(jobs);
    
  public function seq(fn:JobQueue->Automation):Automation       return Automations._.seq(fn,self);
  public function cons(that:Automation):Automation              return Automations._.cons(that,self);

  //public function sequence()
  public function crunch()                              return Automations._.crunch(self);
  public function submit()                              return Automations._.submit(self);

  public function concat(that)                           return Automations._.concat(that,self);
  public function snoc(task)                             return Automations._.snoc(task,self);

  public function prj():AutomationT return this;
  private var self(get,never):Automation;
  private function get_self():Automation return lift(this);
}















//  public function 
  // public function amb(that:Automation):Automation{
  //   var way = Math.random() >= 0.5;
  //   function go(arw0,arw1){

  //   }l
  //   return switch([this,that]){
  //     case [Ended(Val(_)),rhs]            : rhs;
  //     case [lhs,Ended(Val(_))]            : lhs;
  //     case [Ended(Tap),rhs]               : rhs;
  //     case [lhs,Ended(Tap)]               : lhs;
  //     case [Ended(End(e)),_]              : Ended(End(e));
  //     case [_,Ended(End(e))]              : Ended(End(e));
      
  //     case [Await(_,arw0),Await(_,arw1)]  : 
  //     case [Await(_,arw0),Yield(_,arw1)]  :
  //     case [Yield(_,arw0),Await(_,arw1)]  :
  //     case [Yield(_,arw0),Yield(_,arw1)]  :
  //   }
  // }