package stx.run.pack;

import stx.run.announce.Package.Chomp in ChompT;

abstract Chomp<R,E>(ChompT<R,E>) from ChompT<R,E> to ChompT<R,E>{
  static public var inj(default,null)  = new stx.run.pack.chomp.Constructor();

  public function new(self) this = self;
  static public function lift<R,E>(self:ChompT<R,E>):Chomp<R,E> return new Chomp(self);
  

  public function prj():ChompT<R,E> return this;
  private var self(get,never):Chomp<R,E>;
  private function get_self():Chomp<R,E> return lift(this);
}
