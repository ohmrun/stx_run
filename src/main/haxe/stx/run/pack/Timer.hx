package stx.run.pack;

private typedef TimerDef = {
  var created(default,null) : Seconds;
}
@:forward abstract Timer(TimerDef) from TimerDef to TimerDef{
  function new(?self){
    if(self == null){
      this = unit();
    }else{
      this = self;
    }
  }
  static public function pure(v:Seconds):Timer{
    return {
      created : v
    };
  }
  static public function unit():Timer{
    return pure(mark());
  }
  static public function mark():Seconds{
    return haxe.Timer.stamp();
  }
  function copy(?created:Seconds){
    return pure(created == null ? this.created : created);
  }
  public function start():Timer{
    return copy(mark());
  }
  public function since():Seconds{
    return mark() - this.created;
  }
  function prj(){
    return this;
  }
}