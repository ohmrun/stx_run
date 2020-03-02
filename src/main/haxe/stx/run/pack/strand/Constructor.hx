package stx.run.pack.strand;

import stx.run.type.Package.Strand in StrandT;

@:allow(stx)class Constructor{
  public function new(){}
  public var _(default,null) = new Destructure();

  public function lift<O>(cont:StrandT<O>):Strand<O>   return new Strand(cont);
  public function unit<O>():Strand<O>                  return lift((o:O,auto:Automation) -> auto);
}