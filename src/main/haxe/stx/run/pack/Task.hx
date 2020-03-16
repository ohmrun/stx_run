package stx.run.pack;

import stx.run.pack.task.term.Base;

import stx.run.pack.task.Constructor;

@:using(stx.run.pack.task.Implementation)
@:forward abstract Task(TaskApi) from TaskApi to TaskApi{
  static public var ZERO(default,null) : Task = new Task(new Base());
  static public inline function _() return new Constructor();
  public function new(self) this = self;
  
   
  @:to public function toAutomation(){return this;}

  static public function unit()                                                               return _().unit();

  static public function Anon(pursue:Void->Void,?escape:Void->Void,?cleanup:Void->Void):Task  return _().Anon(pursue,escape,cleanup);
  static public function All(gen)                                                             return _().All(gen);
  static public function Seq(gen)                                                             return _().Seq(gen);
  static public function Timeout(milliseconds)                                                return _().Timeout(milliseconds);
  
  static public function fromReactor(reactor)                                                 return _().fromReactor(reactor);
  static public function fromError(error)                                                     return _().fromError(error);
  static public function fromFuture(future)                                                   return _().fromFuture(future);
}