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

  override function do_pursue() {
    this._pursue();
    return super.do_pursue();
  }
  override function do_escape() {
    this._escape();
    super.do_escape();
  }
  override function do_cleanup() {
    this._cleanup();
    super.do_cleanup();
  }
}