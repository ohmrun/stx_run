package stx.run.pack.strand;

class Destructure extends Clazz{
  public function command<O>(self:Strand<O>,cb:O->Void):Strand<O>{
    return Strand.lift(
      (o:O,auto:Automation) -> {
        __.log().trace('command called');
        cb(o);
        return self(o,auto);
      }
    );
  }
}
