package stx.run.pack.act.term;

class Delay extends Base{
  var milliseconds : Int;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
  }
  override public function upply(thk){
    Run._().unit().upply(
      Schedule.Task(
        Task.Timeout(milliseconds).seq(
          Task._().Anon(thk)
        )
      )
    );
  }
} 