package stx.run.pack;

import stx.run.type.Package.Strand in StrandT;

@:forward @:callable abstract Strand<O>(StrandT<O>) from StrandT<O>{
  public function new(self) this = self;

  static public var inj(default,never) = new stx.run.pack.strand.Constructor();


  static public function lift<O>(cont:StrandT<O>):Strand<O>     return inj.lift(cont);
  static public function unit<O>():Strand<O>                    return inj.unit();  

  public function command(cb:O->Void):Strand<O>                 return inj._.command(self,cb);
  
  
  
  private var self(get,never):Strand<O>;
  private function get_self():Strand<O> return lift(this);

  public function prj():StrandT<O> return this;

}