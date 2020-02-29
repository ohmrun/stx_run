package stx.run.type;

typedef Limit = {
  @:optional var unchanged : Int;//how many times can the progression be unchanged before bailing out.

  @:optional var duration  : Int;//milliseconds how long can this process take in total ''.
  @:optional var hanging   : Int;//milliseconds how long can the progression be unchanged ''.
}