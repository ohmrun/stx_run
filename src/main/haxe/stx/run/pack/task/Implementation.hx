package stx.run.pack.task;

class Implementation{
  static public function _() return Constructor.ZERO;
  static public function seq(self:Task,that:Task):Task return _()._.seq(that,self);
}  