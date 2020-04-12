package stx.run.pack.task.term;

class Timeout extends Base{
  var init         = false;
  var timer        : Timer;
  var milliseconds : MilliSeconds;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
    this.timer        = __.timer();
  }
  override function do_pursue(){
    __.log().trace('do_pursue: Timeout: ${this.progress.data}');
    if(!init){
      init  = true;
      this.timer = timer.start();
    }
    var seconds = milliseconds.toSeconds();
    return if(this.timer.since() < seconds){
      var rest = seconds - this.timer.since();
      if(rest <= 0){
        progression(Secured);  
        false;
      }else{
        progression(Polling(rest.toMilliSeconds()));
        true;
      }
    }else{
      progression(Secured);
      false;
    }
  } 
}