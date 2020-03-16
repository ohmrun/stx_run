package stx.run.pack.automation;

class Destructure extends Clazz{
  var log = __.log().trace;
  
  public function concat(that:Automation,self:Automation):Automation{
    return Task.Seq([self.prj(),that.prj()].toIter().toGenerator());
  }
  public function both(that:Automation,self:Automation):Automation{
    return Task.All([that.prj(),self.prj()].toIter().toGenerator());
  }
  public function cons(task:Task,self:Automation):Automation{
    return Task.Seq([task,self].toIter().toGenerator());
  }
  public function snoc(task:Task,self:Automation):Automation{
    return Task.Seq([self,task].toIter().toGenerator());
  }
  function run(self:Automation,?sync=false,?limit){
    var schedule = Schedule.Task(self);

    Run.unit().upply(schedule);
  }
  /**
    Submit the Automation to Run;
  **/
  public function submit(self:Automation,?limit){
    this.run(self,false,limit);
  }
  /**
    Run the Automation inline;
  **/
  // public function crunch(self:Automation,?limit){
  //   this.run(self,true,limit);
  // }  
}   