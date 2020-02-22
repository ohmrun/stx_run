package stx.run.pack;

class AnonymousTask extends TaskBase{
  public function new(perform,?release,?cleanup){
    super();
    this._perform = perform;
    this._release = __.option(release).defv(()->{});
    this._cleanup = __.option(cleanup).defv(()->{});
  }
  var _perform : Block;
  var _release : Block;
  var _cleanup : Block;

  override function doPerform() {
    this._perform();
    super.doPerform();
  }
  override function doRelease() {
    this._release();
    super.doRelease();
  }
  override function doCleanup() {
    this._cleanup();
    super.doCleanup();
  }
}