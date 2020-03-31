package stx.run.pack;

//import stx.run.pack.run.term.Eager;
import stx.run.pack.run.term.Base;

@:forward abstract Run(RunApi) from RunApi{
  
  private function new(fn) this = fn;

  static public function unit():Run{
    return new Base().asRunApi();
  }
}