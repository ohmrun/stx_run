package stx.run.pack.task;

interface Interface{
  public var progress(get,set): Progression;
  function get_progress():Progression;
  function set_progress(ts:Progression):Progression;

  public var working(get,null): Bool;
  function get_working():Bool;

  public var hanging(get,null): Bool;
  function get_hanging():Bool;

  
  public function pursue():Void;
  public function escape():Void;

  public function asTask():Interface;
  public function asDeferred():Interface;
}