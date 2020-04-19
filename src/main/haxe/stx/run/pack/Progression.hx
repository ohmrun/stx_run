package stx.run.pack;

@:forward abstract Progression(Unique<Progress>) from (Unique<Progress>){
  public function new(self){
    return this = self;
  }
  @:from static public function fromProgressSum(sum:ProgressSum):Progression{
    return pure(sum);
  }

  static public function make(sum:Progress):Progression{
    return new Progression(Unique.pure(sum));
  }
  static public function pure(sum:Progress):Progression{
    return make(sum);
  }

  public function is_less_than(that:Progression){
    return this.data.is_less_than(that.data);
  }
  public function error(){{
    return this.data.error();
  }}
  public function is_polling(){
    return this.data.is_polling();
  }
  public function has_problem(){
    return this.data.has_problem();
  }
  public var ongoing(get,never): Bool;
  public function get_ongoing():Bool{
    return this.data.ongoing;
  }
}