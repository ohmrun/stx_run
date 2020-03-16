package stx.run.pack.task.term;

class Timeout extends Base{
  var init         = false;
  var timer        : Timer;
  var milliseconds : Int;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
    this.timer        = __.timer();
  }
  override function do_pursue(){
    if(!init){
      init  = true;
      this.timer = timer.start();
    }
    var seconds = milliseconds / 1000;

    return if(this.timer.since() < seconds){
      var rest = seconds - this.timer.since();
      if(rest <= 0){
        progression(Secured);  
        false;
      }else{
        progression(Polling(Math.round(rest*1000)));
        true;
      }
    }else{
      progression(Secured);
      false;
    }
  } 
}