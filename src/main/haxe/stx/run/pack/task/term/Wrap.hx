package stx.run.pack.task.term;

class Wrap implements TaskApi{

  private var delegate : Task;
  public  var rtid(default,null): Void->Void;  
  public  var progress(get,set): Progression;

  public function new(delegate){
    this.delegate = delegate;
    this.rtid     = ()->{}
  }
  public function pursue(){
    return this.delegate.pursue();
  }
  public function escape(){
    return this.delegate.escape();
  }
  private function get_progress():Progression{
    return this.delegate.get_progress();
  }
  private function set_progress(ts:Progression):Progression{
    return this.delegate.set_progress(ts);
  }
	public function toString(){
		return this.delegate.toString();
  }
  public function asTaskApi():TaskApi{
    return this;
  }
}