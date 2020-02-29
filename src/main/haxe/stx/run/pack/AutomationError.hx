package stx.run.pack;

class AutomationError extends TypedError<AutomationFailure<Dynamic>>{
  static public var UUID(default,never):String = "7512d8c7-87bd-4b09-8f85-f3fd63c47309";
  override private function get_uuid(){
    return UUID;
  }
  static public function make(data:AutomationFailure<Dynamic>, ?prev:Option<TypedError<AutomationFailure<Dynamic>>>, ?pos:Pos):AutomationError{
    var code    = 500;
    var message = Std.string(data);
    return new AutomationError(code,message,Some(data),prev,pos);
  }
}