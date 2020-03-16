package stx.run.pack.task.term;

class Race extends Base{

  var init  : Bool = false;
  var lhs   : Task;
  var rhs   : Task;
  
  public function new(lhs,rhs){
    this.lhs = lhs;
    this.rhs = rhs;
  }

  override public function do_pursue(){
    return switch([lhs.progress.data,rhs.progress.data]){
      case [Escaped,Escaped]    : 
        progression(Escaped);
        false;
      case [Problem(err),_]     : 
        progression(Problem(err));
        false;
      case [_,Problem(err)]     : 
        progression(Problem(err));
        false;
      case [Secured,_] :
        rhs.escape();
        progression(Secured);
        false;
      case [_,Secured]  :
        lhs.escape();
        progression(Secured);
        false;
      case [Escaped,Pending]      : 
        rhs.pursue();
        progression(rhs.progress.data);
        post(rhs);
      case [Escaped,Polling(_)]   : 
        progression(rhs.progress.data);
        true;
      case [Escaped,Waiting(_)]   : 
        progression(rhs.progress.data);
        true;
      case [Pending,Escaped]      : 
        lhs.pursue();
        progression(progress);
        post(lhs);
      case [Polling(_),Escaped]   : 
        progression(lhs.progress.data);
        true;
      case [Waiting(_),Escaped]   : 
        progression(lhs.progress.data);
        true;
      case [Waiting(l),Waiting(r)] : 
        var l_trigger = Future.trigger();
        var l_future  = l_trigger.asFuture();

        var r_trigger = Future.trigger();
        var r_future  = r_trigger.asFuture();

        var b_future  = l_future.first(r_future);

        progression(Waiting(
          Reactor.into(
            (cb) -> b_future.handle(cb)
          )
        ));
        l.apply(l_trigger);
        r.apply(r_trigger);
        false;
      case [Polling(l),Polling(r)]  : 
        progression(Polling(Math.round(Math.min(l,r))));
        true;
      case [Polling(p),_]  :
        progression(Polling(p));
      case [_,Polling(p)]  :
        progression(Polling(p));
    }
  }
  override public function do_escape(){
    lhs.escape();
    rhs.escape();
  }
}