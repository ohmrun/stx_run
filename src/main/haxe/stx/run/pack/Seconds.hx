package stx.run.pack;

abstract Seconds(Float) from Float{
  @:op(A * B)
  public inline function mul(that:Seconds):Seconds{
    return this * that.prj();
  }
  @:op(A / B)
  public inline function div(that:Seconds):Seconds{
    return this / that.prj();
  }
  @:op(A + A)
  public inline function add(that:Seconds):Seconds{
    return this + that.prj();
  }
  @:op(A - A)
  public inline function sub(that:Seconds):Seconds{
    return this - that.prj();
  }
  @:op(A > A)
  public inline function gt(that:Seconds):Bool{
    return this > that.prj();
  }
  @:op(A >= A)
  public inline function gteq(that:Seconds):Bool{
    return this >= that.prj();
  }
  @:op(A < A)
  public inline function lt(that:Seconds):Bool{
    return this < that.prj();
  }
  @:op(A <= A)
  public inline function lteq(that:Seconds):Bool{
    return this < that.prj();
  }
  public inline function toMilliSeconds():MilliSeconds{
    return Math.round(this * 1000);
  }
  private function prj():Float{
    return this;
  }
}