package stx.run.type;

interface TaskApi{
  public var progress(get,set): Progression;
  function get_progress():Progression;
  function set_progress(ts:Progression):Progression;

  public var working(get,null): Bool;
  function get_working():Bool;

  public var ongoing(get,null): Bool;
  function get_ongoing():Bool;

  public function pursue():Void;
  public function escape():Void;

  public function asTaskApi():TaskApi;

  public function toDeferred():TaskApi;
  public function toSchedule():Schedule;
}