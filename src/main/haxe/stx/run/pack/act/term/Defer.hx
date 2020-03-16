package stx.run.pack.act.term;

import haxe.MainLoop;

class Defer extends Base{
  
  override public function upply(thk){
    var fn    = null;
        fn    = () -> {
          thk();
          fn = () -> {};
        };
    var event = null;
        event = MainLoop.add(
          () -> { 
            fn();
            if(event!=null){
              event.stop();
            }
          }
        );
  }
}