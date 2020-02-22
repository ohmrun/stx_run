package stx.run.pack;

import stx.run.head.data.JobQueue in JobQueueT;

@:forward(is_defined)abstract JobQueue(JobQueueT){
  public function new(self) this = self;
  static public function lift(self:JobQueueT):JobQueue return new JobQueue(self);
  static public function unit() return lift([]);

  
  public function prj():JobQueueT return this;
  private var self(get,never):JobQueue;
  private function get_self():JobQueue return lift(this);

  public function automation():Automation{
    return Automation.lift(Ended(Val(self)));
  }
  public function concat(that:JobQueue):JobQueue{
    return lift(this.concat(that.prj()));
  }
  public function snoc(job:Task):JobQueue{
    return lift(this.snoc(job));
  }
}