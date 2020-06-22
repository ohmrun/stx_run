# stx_run

Task library based on coroutines.

This library is comprised of two `Coroutine`s. `Job` is a coroutine that emits `Stat`, which describes how long that coroutine has been in interpretation, and returns some value on `Halt`. 

When the halt value has some found home, it can be transformed to an `Agenda` which can be composed with other `Agenda`s in such a way as it always schedules the one which has spent less time being interpreted, using `Stat` to do so. 

`Agenda` has two compositions: `seq`, which runs one and then the other, and `par`, which oscilates between the two coroutines. 

## Current State

The only worry currently is related to cleanups in early terminations.
