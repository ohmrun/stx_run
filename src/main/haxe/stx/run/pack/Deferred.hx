package stx.run.pack;

class Deferred extends TaskBase{
  var impl    : Observer<Task>;
  var init    : Bool;
  var done    : Bool;
  
  public function new(impl){
    this.impl   = impl;
    super();
  }
  override function doCleanup()
    this.impl = null;//TODO

  /* 
    TODO 
  */
  override function doPerform(){
    if(!init){
      //__.log().trace('deferred called');
      init = true;

      this.impl(
        (x) -> {
          x.perform();
          /*
        __.log().trace({
            definition  : x.definition().map((x) -> x.ident()),
            state       : x.state,
            recurring   : x.recurring
          });*/
          this.state = x.state;
        }
      );
    }
  }
  override function doRelease(){
    this.impl(
      (x) -> x.release()
    );
  }
}