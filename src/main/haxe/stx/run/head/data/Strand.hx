package stx.run.head.data;

typedef Continue<T> = {
  function apply(v:T):Task<Noise>;
}