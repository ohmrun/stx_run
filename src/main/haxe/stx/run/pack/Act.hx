package stx.run.pack;

import stx.run.pack.act.term.Anon;
import stx.run.pack.act.term.Delay;
import stx.run.pack.act.term.Defer;
import stx.run.pack.act.term.MainThread;

import haxe.MainLoop;

@:forward abstract Act(ActApi) from ActApi{
  private function new(fn) this = fn;

  @:noUsing static public function Delay(milliseconds):Act               return new Delay(milliseconds).asActApi();
  @:noUsing static public function Anon(fn):Act                          return new Anon(fn).asActApi();
  @:noUsing static public function Defer():Act                           return new Defer().asActApi();
  @:noUsing static public function MainThread():Act                      return new MainThread().asActApi();
}