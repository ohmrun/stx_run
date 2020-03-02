package stx.run.pack;

class Spinner{
  public var tasks(default,null)    : Array<Task>;
  public var limit(default,null)    : Limit;
  public var backoff(default,null)  : Backoff;
  //public var profile(default,null)  : Profile;

  public function new(limit){
    this.limit      = limit;
    //this.profile    = Profile.conf(limit);
  }
  /**
    Reacts when there's something to do.
    returning wait == true
    returning poll == false
  **/
  public function spin(tasks:Array<Task>):ReactorDef<Bool>{
  return Reactor.inj().into(
      (cb) -> {
        var done  = false;
        var waits : Array<ReactorDef<Noise>>  = [];
        var polls : Array<Int>                = [];

        for(task in tasks){
          switch(task.progress.data){
            case Pending : 
              done = true;
              task.pursue();
              cb(true);
              break;
            case Unready :
            case Polling(milliseconds):
              polls.prj().push(milliseconds);
            case Waiting(cb):
              waits.prj().push(cb);
            case Problem(e):
              done = true;
              throw(e);
              cb(true);
              break;
            case Reready:
              done = true;
              cb(true);
            case Already:
          }
        }
        if(!done){
          switch([waits.is_defined(),polls.is_defined()]){
            case [true,true] : 
              var wait_any = get_wait_any(waits);
              var poll_any = get_poll_any(polls);
              wait_any.or(poll_any).map(_ -> true).upply(cb);
            case [true,false] : 
              get_wait_any(waits).map(_ -> true).upply(cb);
            case [false,true]   : 
              get_poll_any(polls).map(_ -> false).upply(cb);
            case [false,false]  :
              var backoff = __.run().delay(backoff.delta);
              var limits  = __.run().delay(limit.hanging);
              backoff.or(limits).map(_ -> false).upply(cb);
          }
        }
      }
    );
  }
  //anything that's waiting
  function get_wait_any(waits:Array<ReactorDef<Noise>>){
    return Reactor.inj().any(waits).def(Reactor.inj().unit);
  }
  //earliest poll invitation
  function get_poll_any(polls:Array<Int>){
    return __.run().delay(polls.lfold(
      (next,memo) -> return next < memo ? next : memo,
      0
    ));
  }
}