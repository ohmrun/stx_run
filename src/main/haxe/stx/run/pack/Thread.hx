package stx.run.pack;

abstract Thread(Automation->Automation) from Automation->Automation{
  public function new(self){
    this = self;
  }
}