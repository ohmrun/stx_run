package stx.run.pack;

class RunError extends Err<RunFailure<Dynamic>>{
  static public var UUID(default,never):String = "7512d8c7-87bd-4b09-8f85-f3fd63c47309";
  override private function get_uuid(){
    return UUID;
  }
  static public function make(data:RunFailure<Dynamic>, ?prev:Option<Err<RunFailure<Dynamic>>>, ?pos:Pos):RunError{
    var message = Std.string(data);
    
    return new RunError(Some(ERR_OF(data)),prev,pos);
  }
}