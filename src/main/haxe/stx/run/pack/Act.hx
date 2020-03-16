package stx.run.pack;

import stx.run.pack.act.term.Anon;
import stx.run.pack.act.term.Delay;
import stx.run.pack.act.term.Eager;
import stx.run.pack.act.term.Defer;
import stx.run.pack.act.term.MainThread;

import haxe.MainLoop;

@:forward abstract Act(ActApi) from ActApi{
  static public function _() return Constructor.ZERO;
  private function new(fn) this = fn;

  static public inline function Delay(milliseconds):Act               return _().Delay(milliseconds);
  static public inline function Anon(fn):Act                          return _().Anon(fn);
  static public inline function Defer():Act                           return _().Defer();
  static public inline function Eager():Act                           return _().Eager();
  static public inline function MainThread():Act                      return _().MainThread();
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  
  public function Delay(milliseconds):Act               return new Delay(milliseconds).asActApi();
  public function Anon(fn):Act                          return new Anon(fn).asActApi();
  public function Defer():Act                           return new Defer().asActApi();
  public function Eager():Act                           return new Eager().asActApi();
  public function MainThread():Act                      return new MainThread().asActApi();
}