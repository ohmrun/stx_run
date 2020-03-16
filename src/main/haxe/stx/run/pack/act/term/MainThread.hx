package stx.run.pack.act.term;

import haxe.MainLoop;

class MainThread extends Base{
  override public function upply(thk){
    MainLoop.runInMainThread(thk);
  }
}