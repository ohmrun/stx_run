package stx.run.pack;

abstract MilliSeconds(Int) from Int{
  public inline function toSeconds():Seconds{
    return this / 1000;
  }
  @:op(A * A)
  public inline function mul(f:Float):Seconds{
    return toSeconds() * f;
  }
  @:op(A > A)
  public inline function gt(that:MilliSeconds):Bool{
    return this > that.prj();
  }
  @:op(A >= A)
  public inline function gteq(that:MilliSeconds):Bool{
    return this >= that.prj();
  }
  @:op(A < A)
  public inline function lt(that:MilliSeconds):Bool{
    return this < that.prj();
  }
  @:op(A <= A)
  public inline function lteq(that:MilliSeconds):Bool{
    return this < that.prj();
  }
  private function prj():Int{
    return this;
  }
}