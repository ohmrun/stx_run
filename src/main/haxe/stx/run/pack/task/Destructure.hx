package stx.run.pack.task;


class Destructure extends Clazz{
  public function seq(that:Task,self:Task):Task{
    return new Seq([self,that].toIter().toGenerator());
  }
}