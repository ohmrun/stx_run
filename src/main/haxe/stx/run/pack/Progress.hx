package stx.run.pack;


enum ProgressSum{
  Problem(e:Err<AutomationFailure<Dynamic>>);
  Pending;
  
  Polling(milliseconds:MilliSeconds);  
  Waiting(cb:Future<Noise>);  
  Working;

  Secured;
  Escaped;
}
abstract Progress(ProgressSum) from ProgressSum to ProgressSum{
  public function new(self) this = self;
  public function error():Report<AutomationFailure<Dynamic>>{
    return switch(this){
      case Problem(e) : Some(e);
      default         : None;
    }
  }
  public function is_less_than(that:Progress){
    return switch([this,that]){
      case [Polling(a),Polling(b)]  : a < b;
      default                       : 
        Type.enumIndex(this) < Type.enumIndex(that);
    }
  }
  public function prj():ProgressSum{
    return this;
  }
  @:to public function toProgression():Progression{
    return Progression.pure(this);
  }
  public function is_polling(){
    return switch(this){
      case Polling(_) : true;
      default : false;
    }
  }
  public function has_problem(){
    return switch(this){
      case Problem(_) : true;
      default : false;
    }
  }
  public var ongoing(get,never): Bool;
  public function get_ongoing():Bool{
    return switch(this){
      case Pending | Polling(_) | Waiting(_) | Working : true;
      default : false;
    }
  }
} 