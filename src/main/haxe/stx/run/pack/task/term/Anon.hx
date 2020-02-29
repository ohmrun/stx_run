package stx.run.pack.task.term;

class Anon extends Base{
  public function new(pursue,?escape,?cleanup){
    super();
    this._pursue = pursue;
    this._escape = __.option(escape).defv(()->{});
    
    this._cleanup = __.option(cleanup).defv(()->{});
  }
  var _pursue : Block;
  var _escape : Block;

  var _cleanup : Block;

  override function doPursue() {
    this._pursue();
    return super.doPursue();
  }
  override function doEscape() {
    this._escape();
    super.doEscape();
  }
  override function doCleanup() {
    this._cleanup();
    super.doCleanup();
  }
}