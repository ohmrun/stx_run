package stx.run.pack.automation;

class Implementation{
  static public function _() return Automation._()._;

  static public function snoc(self:Automation,task:Task)                                return _().snoc(task,self);
  static public function cons(self:Automation,task:Task):Automation                     return _().cons(task,self);
  
  static public function crunch(self:Automation)                                        return _().crunch(self);
  static public function submit(self:Automation)                                        return _().submit(self);
}