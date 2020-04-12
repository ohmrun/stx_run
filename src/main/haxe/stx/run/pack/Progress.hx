package stx.run.pack;

enum ProgressSum{
  Pending;

  Polling(milliseconds:MilliSeconds);  
  Waiting(cb:Future<Noise>);
  Working;

  Problem(e:Err<AutomationFailure<Dynamic>>);
  
  Escaped;
  Secured;
}
abstract Progress(ProgressSum) from ProgressSum to ProgressSum{
  public function new(self) this = self;
  public function error():Option<Err<AutomationFailure<Dynamic>>>{
    return switch(this){
      case Problem(e) : Some(e);
      default         : None;
    }
  }
  public function is_less_than(that:Progress){
    return switch([this,that]){
      case [_,Working]              : false;
      case [Pending,_]              : true;
      case [_,Secured]              : true;
      case [Polling(a),Polling(b)]  : a < b;
      case [Polling(_),Waiting(_)]  : true;
      case [Waiting(_),Polling(_)]  : false;
      default                       : false;
    }
  }
  public function prj():ProgressSum{
    return this;
  }
} 