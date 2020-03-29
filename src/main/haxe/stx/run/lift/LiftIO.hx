package stx.run.lift;

class LiftIO{
  static public function apply<O,R>(rc:Recall<Automation,O,R>,cont:Sink<O>):R{
    return rc.applyII(Automation.unit(),cont);
  }
}