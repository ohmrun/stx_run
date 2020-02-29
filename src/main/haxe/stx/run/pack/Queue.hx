package stx.run.pack;

import stx.run.pack.queue.TypeDef in QueueT;

@:forward(is_defined)abstract Queue(QueueT){
  public function new(self) this = self;
  static public function lift(self:QueueT):Queue return new Queue(self);
  static public function unit() return lift([]);

  
  public function prj():QueueT return this;
  private var self(get,never):Queue;
  private function get_self():Queue return lift(this);

  public function automation():Automation{
    return Automation.lift(Release(self));
  }
  public function concat(that:Queue):Queue{
    return lift(this.concat(that.prj()));
  }
  public function snoc(job:Task):Queue{
    return lift(this.snoc(job));
  }
  public function cons(job:Task):Queue{
    return lift(this.cons(job));
  }
  public function operate(push:(Void->Void) -> Void,?limit){
    var profile = Profile.conf(limit);    
    //var fn      = folder.bind(profile,push);
    var spinner = new Spinner(Profile.conf(limit).limit);

    function rec(self:Array<Task>){
      spinner.spin(self)(
        (changed) -> {
          if(changed){
            profile = profile.change();
          }else{
            profile = profile.repeat();  
          }
          if(profile.test() == false){
            
          }
          var next = self.filter(
            (task) -> switch(task.progress.data){
              case Already  :false;
              default       : true;              
            }
          );
          if(next.is_defined()){
            rec(next);
          }
        }
      );
    };
    rec(this);
  } 
  static function folder(profile:Profile,push,memo:Array<Task>,next:Task){
    return switch(next.progress.data){
      case Pending: 
        //push(next.pursue);
        //memo.snoc(next);
      case Unready:
        //memo.snoc(next);
      case Polling(float):
        //if(Timer.unit().created > profile.modified + float){
          //push(next.pursue);
        //}
        //memo.snoc(next);
      case Waiting(res):
        // res(
        //   (_) -> {
        //     push(next);//??
        //     profile = profile.dec();
        //   }
        // );
        //profile = profile.inc();
      case Problem(e): //throw(e);
      case Reready:     //memo.snoc(next);
      case Already:
    }
  }
}