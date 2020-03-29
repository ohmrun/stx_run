package stx.run.pack.strand;

@:allow(stx)class Constructor{
  public function new(){}
  public var _(default,null) = new Destructure();

  public function lift<O>(cont:StrandDef<O>):Strand<O>   return new Strand(cont);
  public function unit<O>():Strand<O>                  return lift((o:O,auto:Automation) -> auto);
}